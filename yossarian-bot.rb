# frozen_string_literal: true

#  -*- coding: utf-8 -*-
#  yossarian-bot.rb
#  Author: William Woodruff
#  ------------------------
#  A call-and-response IRC bot for entertainment.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "set"
require "cinch"
require "cinch/plugins/identify"
require "yaml"

config_file = File.expand_path(File.join(File.dirname(__FILE__), "config.yml"))
version_file = File.expand_path(File.join(File.dirname(__FILE__), "version.yml"))
plugins_file = File.expand_path(File.join(File.dirname(__FILE__), "plugins.yml"))

if File.file?(config_file) && File.file?(version_file) && File.file?(plugins_file)
  config = YAML.load_file(config_file)
  version = YAML.load_file(version_file)
  plugins = YAML.load_file(plugins_file)["plugins"]
else
  abort("Fatal: Missing one of: config.yml, version.yml, plugins.yml.")
end

# Update the environment before we load extensions and plugins.
ENV.update(config["environment"] || {})

Dir[File.dirname(__FILE__) + "/extend/**/*.rb"].each do |extension|
  require extension
end

Dir[File.dirname(__FILE__) + "/plugins/**/*.rb"].each do |plugin|
  require plugin
end

server_threads = []

# rubocop:disable Metrics/BlockLength
config["servers"].each do |server_name, server_info|
  server_threads << Thread.new do
    Cinch::Bot.new do
      @starttime = Time.now
      @version = version
      @admins = server_info["admins"] || []
      @blacklist = server_info["blacklist"]&.to_set || Set.new
      @all_plugins = plugins.map do |plugin|
        Object.const_get(plugin)
      end
      @server_id = server_info["server_id"] || server_name

      # rubocop:disable Style/TrivialAccessors
      def starttime
        @starttime
      end

      def version
        @version
      end

      def admins
        @admins
      end

      def blacklist
        @blacklist
      end

      def all_plugins
        @all_plugins
      end

      def server_id
        @server_id
      end
      # rubocop:enable Style/TrivialAccessors

      configure do |conf|
        conf.nick = server_info["nick"] || "yossarian-bot"
        conf.realname = "yossarian-bot"
        conf.user = "yossarian-bot"
        conf.max_messages = 1
        conf.server = server_name
        conf.channels = server_info["channels"]
        conf.port = server_info["port"] || 6667
        conf.ssl.use = server_info["ssl"] || false
        conf.plugins.prefix = Regexp.new(server_info["prefix"] || /^!/)
        conf.plugins.plugins = @all_plugins.dup
        conf.plugins.plugins << Cinch::Plugins::Identify

        if server_info.key? "sasl"
          conf.sasl.username = server_info["sasl"]["password"] || conf.nick
          conf.sasl.password = server_info["sasl"]["password"]
        end

        if server_info.key?("auth")
          conf.plugins.options[Cinch::Plugins::Identify] = {
            type: server_info["auth"]["type"].to_sym,
            password: server_info["auth"]["password"],
          }
        end

        if server_info.key?("disabled_plugins")
          server_info["disabled_plugins"].each do |plugin|
            conf.plugins.plugins.delete(Object.const_get(plugin))
          end
        end
      end
    end.start
  end
end
# rubocop:enable Metrics/BlockLength

server_threads.each(&:join)
