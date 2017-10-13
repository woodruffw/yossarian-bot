#  -*- coding: utf-8 -*-
#  rainbow_text.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that generates rainbow text for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class RainbowText < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  COLORS = ["03", "04", "06", "07", "08", "09", "11", "13"]

  def usage
    "!rainbow <text> - Vomit out rainbowified text. Alias: !vomit."
  end

  def match?(cmd)
    cmd =~ /^(!)?(rainbow)|(vomit)$/
  end

  match /rainbow (.+)/, method: :rainbow_text, strip_colors: true
  match /vomit (.+)/, method: :rainbow_text, strip_colors: true

  def rainbow_text(m, text)
    color_text = text.chars.map do |c|
      "\x03#{COLORS.sample}#{c}\x0F"
    end.join("")

    m.reply color_text, true
  end
end
