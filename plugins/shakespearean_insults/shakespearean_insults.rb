# frozen_string_literal: true

#  shakespearean_insults.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Shakespearean insults for yossarian-bot.
#  shakespearean_insults.yml taken from 'insult-generator' by Arvind Kunday.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"

require_relative "../yossarian_plugin"

class ShakespeareanInsults < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  INSULTS_FILE = File.expand_path(File.join(File.dirname(__FILE__), "shakespearean_insults.yml"))
  INSULTS = YAML.load_file(INSULTS_FILE)

  def usage
    "!insult [nick] - Generate a Shakespearean insult, and insult someone if given."
  end

  def match?(cmd)
    cmd =~ /^(!)?insult$/
  end

  match /insult$/, method: :insult

  def insult(m)
    col1 = INSULTS["column1"].sample
    col2 = INSULTS["column2"].sample
    col3 = INSULTS["column3"].sample

    m.reply "Thou art a #{col1}, #{col2} #{col3}!", true
  end

  match /insult (\S+)/, method: :insult_nick, strip_colors: true

  def insult_nick(m, nick)
    if m.channel.has_user?(nick)
      col1 = INSULTS["column1"].sample
      col2 = INSULTS["column2"].sample
      col3 = INSULTS["column3"].sample

      m.reply "#{nick} is a #{col1}, #{col2} #{col3}!"
    else
      m.reply "I don\'t see #{nick} in this channel."
    end
  end
end
