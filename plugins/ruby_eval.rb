#  -*- coding: utf-8 -*-
#  ruby_eval.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that Ruby evaluation for yossarian-bot.
#  Uses the eval.in service: https://eval.in/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'mechanize'
require 'nokogiri'

require_relative 'yossarian_plugin'

class RubyEval < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'http://eval.in'
	end

	def usage
		'!rb <code> - Evaluate the given Ruby code on eval.in. Alias: !ruby'
	end

	def match?(cmd)
		cmd =~ /^(!)?(?:rb$)|(?:ruby$)/
	end

	match /(?:rb|ruby) (.+)/, method: :ruby_eval, strip_colors: true

	def ruby_eval(m, code)
		mech = Mechanize.new
		mech.user_agent_alias = 'Linux Firefox'
		page = mech.get(@url)

		begin
			form = page.forms.first
			form.field_with(:name => 'code').value = code
			form.field_with(:name => 'lang').value = "ruby/mri-2.2"
			html = Nokogiri::HTML(mech.submit(form).body)
			results = html.css('pre').last.text.gsub("\n", ' ')

			if results.size > 0 
				m.reply results, true
			else
				m.reply 'No output was produced.', true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
