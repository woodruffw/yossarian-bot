#  -*- coding: utf-8 -*-
#  merriam_webster.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Merriam-Webster interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'xmlsimple'
require 'open-uri'

require_relative 'yossarian_plugin'

class MerriamWebster < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@key = ENV['MERRIAM_WEBSTER_API_KEY']
	end

	def usage
		'!define <word> - Get the Merriam-Webster defintion of <word>.'
	end

	def match?(cmd)
		cmd =~ /^(!)?define$/
	end

	match /define (\S+)/, method: :define_word, strip_colors: true

	def define_word(m, word)
		if @key
			query = URI.encode(word)
			url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{query}?key=#{@key}"

			begin
				hash = XmlSimple.xml_in(open(url).read)

				if !hash['content']
					definition = hash['entry'].first['def'].first['dt'].first
					definition.gsub!(':', '')

					m.reply "#{word} - #{definition}", true
				else
					m.reply "No defintion for #{word}.", true
				end
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
