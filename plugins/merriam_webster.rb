#  -*- coding: utf-8 -*-
#  merriam_webster.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Merriam-Webster interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

require_relative 'yossarian_plugin'

class MerriamWebster < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV['MERRIAM_WEBSTER_API_KEY']
  URL = 'http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%{query}?key=%{key}'

  def usage
    '!define <word> - Get the Merriam-Webster defintion of <word>.'
  end

  def match?(cmd)
    cmd =~ /^(!)?define$/
  end

  match /define (\S+)/, method: :define_word, strip_colors: true

  def define_word(m, word)
    if KEY
      query = URI.encode(word)
      url = URL % { query: query, key: KEY }

      begin
        xml = Nokogiri::XML(open(url).read)

        def_elem = xml.xpath('//entry_list/entry/def/dt').first

        if def_elem
          definition = def_elem.text.gsub(':', '')

          m.reply "#{word} - #{definition}.", true
        else
          m.reply "No definition for #{word}.", true
        end
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply 'Internal error (missing API key).'
    end
  end
end
