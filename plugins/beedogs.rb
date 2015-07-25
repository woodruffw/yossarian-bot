#  -*- coding: utf-8 -*-
#  beedogs.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves pictures of Beedogs for yossarian-bot.
#  Beedogs curated by Gina Zycher: http://beedogs.com
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class Beedogs < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	COUNT = 327

	def usage
		'!beedog - Retrieve a random picture of a beedog.'
	end

	def match?(cmd)
		cmd =~ /^(!)?beedog$/
	end

	match /beedog$/, method: :beedog

	def beedog(m)
		num = '%03d' % rand(1..COUNT)

		m.reply "http://beedogs.com/index_files/image#{num}.jpg", true
	end
end
