#  yossarian-helpers.rb
#  Author: William Woodruff
#  ------------------------
#  Methods used by yossarian-bot for various commands.

require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'nokogiri'
require 'wolfram'
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
	when /^(!)?src/
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
	when /^(!)?w/
		return "!w <location> - get weather for <location> from Wunderground."
	when /^(!)?g/
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

def random_quote
	[
		"He was going to live forever, or die in the attempt.",
		"Just because you're paranoid doesn't mean they aren't after you.",
		"Anything worth dying for is certainly worth living for.",
		"Insanity is contagious.",
		"It doesn't make a damned bit of difference who wins the war to someone who's dead.",
		"It doesn't make sense. It isn't even good grammar.",
		"The country was in peril; he was jeopardizing his traditional rights of freedom and independence by daring to exercise them.",
		"I want to keep my dreams, even bad ones, because without them, I might have nothing all night long.",
		"The Texan turned out to be good-natured, generous and likable. In three days no one could stand him.",
		"Some men are born mediocre, some men achieve mediocrity, and some men have mediocrity thrust upon them.",
		"There is no disappointment so numbing...as someone no better than you achieving more.",
		"Destiny is a good thing to accept when it's going your way. When it isn't, don't call it destiny; call it injustice, treachery, or simple bad luck.",
		"Well, he died. You don't get any older than that.",
		"\"Consciously, sir, consciously,\" Yossarian corrected in an effort to help. \"I hate them consciously.\"",
		"Prostitution gives her an opportunity to meet people. It provides fresh air and wholesome exercise, and it keeps her out of trouble.",
		"What would they do to me,\" he asked in confidential tones, \"if I refused to fly them?",
		"\"If you're going to be shot, whose side do you expect me to be on?\" ex-P.F.C. Wintergreen retorted.",
		"\"Because...\" Clevinger sputtered, and turned speechless with frustration. Clevinger really thought he was right, but Yossarian had proof, because strangers he didn't know shot at him with cannons every time he flew up into the air to drop bombs on them, and it wasn't funny at all.",
		"Catch-22 did not exist, he was positive of that, but it made no difference.",
		"He was a self-made man who owed his lack of success to nobody.",
		"Major Major\'s elders disliked him because he was such a flagrant nonconformist.",
		"You have no respect for excessive authority or obsolete traditions. You're dangerous and depraved, and you ought to be taken outside and shot!",
		"Clevinger had a mind, and Lieutenant Scheisskoph had noticed that people with minds tended to get pretty smart at times.",
		"When I grow up I want to be a little boy.",
		"He woke up blinking with a slight pain in his head and opened his eyes upon a world boiling in chaos in which everything was in proper order.",
		"I\'m not running away from my responsibilities. I'm running to them. There\'s nothing negative about running away to save my life.",
		"That\'s some catch, that Catch-22,\" he observed. \"It\'s the best there is,\" Doc Daneeka agreed.",
		"No, no darling. Because you\'re crazy.",
		"When I was a kid, I used to walk around all day with crab apples in my cheeks. One in each cheek.",
		"Catch-22 says they have the right to do anything we can't stop them from doing.",
		"There was one catch, and that was Catch-22.",
		"He was a militant idealist who crusaded against racial bigotry by growing faint in its presence."
	].sample
end

def unix_fortune
	if system('which fortune 2> /dev/null')
		return `fortune`.gsub(/\n/, ' ')
	else
		return 'Internal error (no fortune).'
	end
end

def urban_dict(word)
	query = URI.encode(word)
	data = Net::HTTP.get(URI("http://api.urbandictionary.com/v0/define?term=#{query}"))
	hash = JSON.parse(data)
	if hash['list'].empty?
		return "No definition for #{word}."
	else
		list = hash['list'][0]
		return list['definition'][0..255].gsub(/[\r\n]/, '') +
			"... link: " + list['permalink']
	end
end

def wolfram_alpha(query)
	if ENV.has_key?('WOLFRAM_ALPHA_APPID_KEY')
		Wolfram.appid = ENV['WOLFRAM_ALPHA_APPID_KEY']
		result = Wolfram.fetch(query).pods[1]

		if result == nil || result.plaintext.empty?
			return "Wolfram|Alpha has nothing for #{query}"
		else
			return result.plaintext.gsub(/[\t\r\n]/, '')
		end
	else
		return 'Internal error (missing API key).'
	end
end

def weather(location)
	if ENV.has_key?('WUNDERGROUND_API_KEY')
		wu = Wunderground.new(ENV['WUNDERGROUND_API_KEY'])
		hash = wu.conditions_for(location)

		unless hash['current_observation'] == nil
			loc = hash['current_observation']['display_location']['full']
			weather = hash['current_observation']['weather']
			temp = hash['current_observation']['temperature_string']
			return "Current temperature in #{loc} is #{temp} and #{weather}."
		else
			return "Bad weather query for #{location}."
		end
	else
		return 'Internal error (missing API key).'
	end
end

def google(search)
	url = URI.encode("https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=large&safe=active&q=#{search}")
	hash = JSON.parse(open(url).string)

	unless hash['responseData']['results'].empty?
		site = hash['responseData']['results'][0]['url']
		content = hash['responseData']['results'][0]['content'].gsub(/([\t\r\n])|(<(\/)?b>)/, '')
		content.gsub!(/(&amp;)|(&quot;)|(&lt;)|(&gt;)|(&#39;)/, '&amp;' => '&', '&quot;' => '"', '&lt;' => '<', '&gt;' => '>', '&#39;' => '\'')
		return "#{site} - #{content}"
	else
		return "No Google results for #{search}."
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
