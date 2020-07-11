# frozen_string_literal: true

#  channel_moderator.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs moderates channels for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"

require_relative "../yossarian_plugin"

class ChannelModerator < YossarianPlugin
  include Cinch::Plugin
  use_auth silent: false
  use_opped silent: false

  def initialize(*args)
    super
    @rules_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.server_id, "rules.yml"))

    if File.file?(@rules_file)
      @rules = @rules = YAML.load_file(@rules_file)
      @rules.default_proc = Proc.new { |h, k| h[k] = [] }
    else
      FileUtils.mkdir_p File.dirname(@rules_file)
      @rules = Hash.new { |h, k| h[k] = [] }
    end
  end

  def sync_rules_file
    File.open(@rules_file, "w+") do |file|
      file.write @rules.to_yaml
    end
  end

  def usage
    "!moderator <commands> - Configure channel moderation (admin required). See !help for a link to moderator commands."
  end

  def match?(cmd)
    cmd =~ /^(!)?moderator$/
  end

  listen_to :connect, method: :initialize_rules

  match /moderator add \/(.+)\//, method: :moderator_add_rule, strip_colors: true

  def moderator_add_rule(m, regex)
    regex = Regexp.new(regex, Regexp::IGNORECASE)

    @rules[m.channel.to_s] << regex
    sync_rules_file

    m.reply "Added /#{regex}/ as a rule.", true
  end

  match /moderator del \/(.+)\//, method: :moderator_del_rule, strip_colors: true

  def moderator_del_rule(m, regex)
    regex = Regexp.new(regex, Regexp::IGNORECASE)

    if @rules[m.channel.to_s].include?(regex)
      @rules[m.channel.to_s].delete(regex)
      sync_rules_file

      m.reply "Deleted /#{regex}/ from the rules.", true
    else
      m.reply "No such rule to delete.", true
    end
  end

  match /moderator list$/, method: :moderator_list_rules, strip_colors: true

  def moderator_list_rules(m)
    rules = @rules[m.channel.to_s].map(&:inspect).join(", ")
    m.reply "Current moderation expressions: #{rules}"
  end

  listen_to :channel, strip_colors: true

  def listen(m)
    channel = m.channel.to_s
    message = Sanitize(m.message.delete("\u200B"))

    if @rules.key?(channel) && Regexp.union(@rules[channel]).match(message) && !m.channel.opped?(m.user)
      m.channel.kick m.user, "Please follow channel rules. I\'ve sent them to you in a private message."
      m.user.send "Your message triggered one of these patterns:"
      m.user.send @rules[m.channel.to_s].map { |r| "/#{r}/" }.join(", ")
      m.user.send "If you think a mistake was made, please contact a channel operator."
    end
  end
end
