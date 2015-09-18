#  -*- coding: utf-8 -*-
#  code_eval.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides code evaluation for yossarian-bot.
#  Uses the eval.in service: https://eval.in/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'mechanize'
require 'nokogiri'

require_relative 'yossarian_plugin'

class CodeEval < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	URL = 'http://eval.in'
	LANGS = {
		'c' => 'c/gcc-4.9.1',
		'c++' => 'c++/gcc-4.9.1',
		'coffeescript' => 'coffeescript/node-0.10.29-coffee-1.7.1',
		'fortran' => 'fortran/f95-4.4.3',
		'haskell' => 'haskell/hugs98-sep-2006',
		'io' => 'io/io-20131204',
		'js' => 'javascript/node-0.10.29',
		'lua' => 'lua/lua-5.2.3',
		'ocaml' => 'ocaml/ocaml-4.01.0',
		'php' => 'php/php-5.5.14',
		'pascal' => 'pascal/fpc-2.6.4',
		'perl' => 'perl/perl-5.20.0',
		'python' => 'python/cpython-3.4.1',
		'python2' => 'python/cpython-2.7.8',
		'ruby' => 'ruby/mri-2.2',
		'slash' => 'slash/slash-head',
		'nasm' => 'assembly/nasm-2.07'
	}

	def usage
		'!eval <lang> <code> - Evaluate the given code with the given language on eval.in.'
	end

	def match?(cmd)
		cmd =~ /^(!)?eval$/
	end

	match /eval (\S+) (.+)/, method: :code_eval, strip_colors: true

	def code_eval(m, lang, code)
		lang.downcase!

		if LANGS.key?(lang)
			mech = Mechanize.new
			mech.user_agent_alias = 'Linux Firefox'
			page = mech.get(URL)

			begin
				form = page.forms.first
				form.field_with(:name => 'code').value = code
				form.field_with(:name => 'lang').value = LANGS[lang]
				html = Nokogiri::HTML(mech.submit(form).body)
				results = html.css('pre').last.text.gsub(/[\t\r\n]/, ' ')

				if results.size > 0
					m.reply Sanitize(results), true
				else
					error = html.css('p')[1].text.strip
					m.reply "Error: #{error}.", true
				end
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply "I don\'t know #{lang}.", true
		end
	end
end
