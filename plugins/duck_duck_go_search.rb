#  -*- coding: utf-8 -*-
#  duck_duck_go.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides DuckDuckGo interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'duck_duck_go'

require_relative 'yossarian_plugin'

class DuckDuckGoSearch < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@ddg = DuckDuckGo.new
	end

	def usage
		'!ddg <search> - Search DuckDuckGo\'s Zero Click Info API.'
	end

	def match?(cmd)
		cmd =~ /^(!)?ddg$/
	end

	match /ddg (.+)/, method: :ddg_search, strip_colors: true

	def ddg_search(m, search)
		zci = @ddg.zeroclickinfo(search)

		unless zci.abstract_text == nil
			m.reply zci.abstract_text, true
		else
			m.reply "No results for #{search}.", true
		end
	end
end

