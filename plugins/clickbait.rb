#  -*- coding: utf-8 -*-
#  clickbait.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides clickbait-y titles for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'upworthy'

require_relative 'yossarian_plugin'

class Clickbait < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!clickbait - Generate a clickbait-y title.'
	end

	def match?(cmd)
		cmd =~ /^(!)?clickbait$/
	end

	match /clickbait$/, method: :clickbait

	def clickbait(m)
		m.reply Upworthy.headline, true
	end
end
