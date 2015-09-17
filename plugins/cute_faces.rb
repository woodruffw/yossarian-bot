#  -*- coding: utf-8 -*-
#  cute_faces.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides cute faces for yossarian-bot.
#  Inspired by and derived from cybot's .cute command.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class CuteFaces < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	FACES = [
		"(✿◠‿◠)っ~ ♥ %{nick}", "⊂◉‿◉つ ❤ %{nick}", "( ´・‿-) ~ ♥ %{nick}",
		"(っ⌒‿⌒)っ~ ♥ %{nick}", "ʕ´•ᴥ•`ʔσ” BEARHUG %{nick}",
		"%{user} ~(=^･ω･^)ヾ(^^ ) %{nick}",
		"%{user} (◎｀・ω・´)人(´・ω・｀*) %{nick}",
		"%{user} (*´・ω・)ノ(-ω-｀*) %{nick}", "%{user} (ɔ ˘⌣˘)˘⌣˘ c) %{nick}",
		"%{nick} (´ε｀ )♡",	"(⊃｡•́‿•̀｡)⊃ U GONNA GET HUGGED %{nick}",
		"%{user} (◦˘ З(◦’ںˉ◦)♡ %{nick}",  "( ＾◡＾)っ~ ❤ %{nick}",
		"(◡‿◕✿)~★ %{nick}","(◡﹏◕✿)~★ %{nick}","(◡△◕✿)~★ %{nick}",
		"(◡ω◕✿)~★ %{nick}","(◡︿◕✿)~★ %{nick}","(◡︿⊙✿)~★ %{nick}",
		"(◡ω⊙✿)~★ %{nick}","(◡‿◡✿)~★ %{nick}","(◡‿⊙✿)~★ %{nick}",
		"(◠‿◕✿)~★ %{nick}","(◠︿⊙✿)~★ %{nick}","(◠ω⊙✿)~★ %{nick}",
		"(◠△⊙✿)~★ %{nick}","(◠﹏⊙✿)~★ %{nick}","(◠︿◕✿)~★ %{nick}",
		"(◠ω◕✿)~★ %{nick}","(◠△◕✿)~★ %{nick}","(◠﹏◕✿)~★ %{nick}",
		"(◡︿◡✿)~★ %{nick}","(◡ω◡✿)~★ %{nick}","(◡△◡✿)~★ %{nick}",
		"(◡﹏◡✿)~★ %{nick}","(◡︿⊙✿)~★ %{nick}","(◡ω⊙✿)~★ %{nick}",
		"(◡△⊙✿)~★ %{nick}","(◡﹏⊙✿)~★ %{nick}"
	]

	def usage
		'!cute <nick> - Send a cute face to the given nick.'
	end

	def match?(cmd)
		cmd =~ /^(!)?cute$/
	end

	match /cute (\S+)/, method: :cute, strip_colors: true

	def cute(m, nick)
		if m.channel.users.key?(User(nick))
			cute = FACES.sample % {user: m.user.nick, nick: nick}
			m.reply cute
		else
			m.reply "I don\'t see #{nick} in this channel."
		end
	end
end
