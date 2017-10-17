#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  wolfram_alpha.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Wolfram|Alpha interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "wolfram"

require_relative "yossarian_plugin"

class WolframAlpha < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["WOLFRAM_ALPHA_APPID_KEY"]

  def usage
    "!wa <query> - Ask Wolfram|Alpha about <query>. Alias: !wolfram."
  end

  def match?(cmd)
    cmd =~ /^(!)?(wolfram)|(wa)$/
  end

  match /wa (.+)/, method: :wolfram_alpha, strip_colors: true
  match /wolfram (.+)/, method: :wolfram_alpha, strip_colors: true

  def wolfram_alpha(m, query)
    if KEY
      Wolfram.appid = KEY
      result = Wolfram.fetch(query).pods[1]

      if result && !result.plaintext.empty?
        # wolfram alpha formats unicode as \:xxxx for some unknown reason
        text = result.plaintext.gsub("\\:", "\\u")

        text.unescape_unicode!
        text.normalize_whitespace!

        m.reply text, true
      else
        m.reply "Wolfram|Alpha has nothing for #{query}", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
