#  -*- coding: utf-8 -*-
#  magic8ball.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Magic 8 Ball answers for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class Magic8Ball < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  ANSWERS = [
    "It is certain.",
    "It is decidedly so.",
    "Without a doubt.",
    "Yes definitely.",
    "You may rely on it.",
    "As I see it, yes.",
    "Most likely.",
    "Outlook good.",
    "Yes.",
    "Signs point to yes.",
    "Reply hazy, try again.",
    "Ask again later.",
    "Better not tell you now.",
    "Cannot predict now.",
    "Concentrate and ask again.",
    "Don't count on it.",
    "My reply is no.",
    "My sources say no.",
    "Outlook not so good.",
    "Very doubtful."
  ]

  def usage
    "!8ball <question> - Ask the Magic 8 Ball a question. Alias: !8b."
  end

  def match?(cmd)
    cmd =~ /^(!)?(8ball)|(8b)$/
  end

  match /8b (.+)/, method: :magic8ball
  match /8ball (.+)/, method: :magic8ball

  def magic8ball(m)
    m.reply ANSWERS.sample, true
  end
end
