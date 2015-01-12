#  yossarian-helpers.rb
#  Author: William Woodruff
#  ------------------------
#  Methods used by yossarian-bot for various commands.

require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'nokogiri'
require 'wunderground'
require 'xml'
require 'cleverbot-api'

def list_help
	return "Available commands: !bots, !author, !botver, !src, !c22, " +
		"!fortune, !say, !pmsg, !ud, !wa, !w, !g, !rot13, !8ball, !define, " +
		"!cb. " +
		"For more info on each, try !help <cmd>."
end

def cmd_help(cmd)
	case cmd
	when /^([!.:])?help/
		return "!help [cmd] - List general help or help on <cmd>."
	when /^([!.:])?bots/
		return "!bots - report self as bot to the channel."
	when /^(!)?author/
		return "!author - the author of yossarian-bot."
	when /^(!)?botver/
		return "!botver - the version of yossarian-bot."
	when /^(!)?s(?:ou)?rc/
		return "!src - a link to yossarian-bot\'s source."
	when /^(!)?c22/
		return "!c22 - get a random Catch-22 quote."
	when /^(!)?fortune/
		return "!fortune - get a random Unix fortune."
	when /^(!)?say/
		return "!say <message> - make the bot say <message>."
	when /^(!)?pmsg/
		return "!pmsg <user> <message> - message <user> with <message> through yossarian-bot"
	when /^(!)?ud/
		return "!ud <phrase> - search UrbanDictionary for <phrase>."
	when /^(!)?wa/
		return "!wa <query> - ask Wolfram|Alpha about <query>."
	when /^(!)?w(?:eather)?/
		return "!w <location> - get weather for <location> from Wunderground."
	when /^(!)?g(?:oogle)?/
		return "!g <search> - get the first Google result for <search>."
	when /^(!)?rot13/
		return "!rot13 <message> - use the ROT-13 cipher on <message>."
	when /^(!)?8ball/
		return "!8ball <question> - ask the Magic 8 Ball a question. Must end with \'?\'."
	when /^(!)?define/
		return "!define <word> - get the Merrian-Webster definition of <word>."
	when /^(!)?cb/
		return "!cb <query> - talk to CleverBot."
	else
		return "#{cmd}: unknown command."
	end
end

def unix_fortune
	if system('which fortune 2> /dev/null')
		return `fortune`.gsub(/\n/, ' ')
	else
		return 'Internal error (no fortune).'
	end
end

def rot13(msg)
	return msg.tr("A-Ma-mN-Zn-z", "N-Zn-zA-Ma-m")
end

def random_8ball
	[
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
	].sample
end

def define_word(word)
	if ENV.has_key?('MERRIAM_WEBSTER_API_KEY')
		url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=#{ENV['MERRIAM_WEBSTER_API_KEY']}"
		doc = XML::Parser.string(open(url).string).parse
		definition = doc.find_first('entry/def[1]/dt[1]').to_s.gsub(/(<(\/)?[A-Za-z0-9_-]+>)|(:)/, '')

		if definition.empty?
			return "No defintion for #{word}."
		else
			return "#{word}: #{definition}."
		end
	else
		return 'Internal error (missing API key).'
	end
end

def cleverbot(query)
	cb = CleverBot.new
	return cb.think(query)
end

def link_title(link)
	html = Nokogiri::HTML(open(link))
	return html.css('title').text.gsub(/[\t\r\n]/, '')
end
