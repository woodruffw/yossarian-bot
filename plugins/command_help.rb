# frozen_string_literal: true

#  command_help.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides command help for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class CommandHelp < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!help [cmd] - Display general help, or help for [cmd]."
  end

  def match?(cmd)
    cmd =~ /^(!)?help$/
  end

  match /help$/, method: :help

  def help(m)
    m.reply "Commands: http://git.io/38F1qA - Use !help <cmd> for info.", true
  end

  match /help (\S+)/, method: :help_cmd

  def help_cmd(m, cmd)
    @bot.plugins.each do |plugin|
      if plugin.respond_to?(:match?) && plugin.match?(cmd)
        m.reply plugin.usage, true
        return
      end
    end
    m.reply "Nothing found for \'#{cmd}\'.", true
  end
end
