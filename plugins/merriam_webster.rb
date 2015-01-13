#  merriam_webster.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Merriam-Webster interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'xml'
require 'open-uri'

require_relative 'yossarian_plugin'

class MerriamWebster < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!define <word> - Get the Merriam-Webster defintion of <word>. Alias: !mw.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(define)|(mw)$/
	end

	match /mw (\w+)/, method: :define_word
	match /define (\w+)/, method: :define_word

	def define_word(m, word)
		if ENV.has_key?('MERRIAM_WEBSTER_API_KEY')
			url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=#{ENV['MERRIAM_WEBSTER_API_KEY']}"
			doc = XML::Parser.string(open(url).string).parse
			definition = doc.find_first('entry/def[1]/dt[1]').to_s.gsub(/(<(\/)?[A-Za-z0-9_-]+>)|(:)/, '')

			if definition.empty?
				m.reply "#{m.user.nick}: No defintion for #{word}."
			else
				m.reply "#{m.user.nick}: #{word} - #{definition}."
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
