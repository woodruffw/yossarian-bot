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

def list_help
	return "Available commands: !help, !bots, !author, !botver, !src, !c22, " +
		"!fortune, !pmsg, !ud, !wa. For more info on each, try !help <cmd>."
end

def cmd_help(cmd)
	case cmd
	when /^(!)?help/
		return "!help [cmd] - List general help or help on <cmd>."
	when /^(!)?bots/
		return "!bots - report self as bot."
	when /^(!)?author/
		return "!author - the author of yossarian-bot."
	when /^(!)?botver/
		return "!botver - the version of yossarian-bot."
	when /^(!)?src/
		return "!src - a link to yossarian-bot\'s source."
	when /^(!)?c22/
		return "!c22 - message a random Catch-22 quote."
	when /^(!)?fortune/
		return "!fortune - message a random Unix fortune."
	when /^(!)?pmsg/
		return "!pmsg <user> <message> - message <user> with <message> through yossarian-bot"
	when /^(!)?ud/
		return "!ud <phrase> - search UrbanDictionary for <phrase>."
	when /^(!)?wa/
		return "!wa <query> - ask Wolfram|Alpha about <query>."
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

def define_word(word)
	query = URI.encode(word)
	data = Net::HTTP.get(URI("http://api.urbandictionary.com/v0/define?term=#{query}"))
	hash = JSON.parse(data)
	if hash['list'].empty?
		return "No definition for #{word}."
	else
		list = hash['list'][0]
		return list['definition'][0..255].gsub(/\r\n/, '') +
			"... link: " + list['permalink']
	end
end

def wolfram_alpha(query)
	Wolfram.appid = ENV['WOLFRAM_ALPHA_APPID_KEY']
	result = Wolfram.fetch(query).pods[1]

	if result == nil
		return "Wolfram|Alpha has nothing for #{query}"
	else
		return result.plaintext.gsub(/\r\n/, '')
	end
end

def link_title(link)
	html = Nokogiri::HTML(open(link))
	return html.css('title').text.gsub(/^[ \t\r\n]*/, '')
end
