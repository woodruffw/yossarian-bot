#  -*- coding: utf-8 -*-
#  google_translate.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin for interfacing with Google Translate.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class GoogleTranslate < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!tr <message>- Translate <message> to English, with optional <from> and <to> for accuracy and other languages. Alias: !translate.'
	end

	def match?(cmd)
		cmd =~ /^(!)?tr(?:anslate)?$/
	end

	match /tr(?:anslate)? (.+)/, method: :google_translate_auto, strip_colors: true

	def google_translate_auto(m, msg)
		begin
			query = URI.encode(msg)
			url = "https://translate.googleapis.com/translate_a/t?client=a&sl=auto&tl=en&q=#{query}"
			hash = JSON.parse(open(url).read)
			result = hash['sentences'][0]['trans']
			m.reply result, true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
