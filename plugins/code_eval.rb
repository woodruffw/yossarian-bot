#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  code_eval.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides code evaluation for yossarian-bot.
#  Uses the eval.in service: https://eval.in/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "eval-in"

require_relative "yossarian_plugin"

class CodeEval < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!eval <lang> <code> - Evaluate the given code with the given language on eval.in. (Use `!eval' to get a list of languages.)"
  end

  def match?(cmd)
    cmd =~ /^(!)?eval$/
  end

  match /eval (\S+) (.+)/, method: :code_eval, strip_colors: true

  def code_eval(m, lang, code)
    result = EvalIn.eval(lang, code)

    m.reply result.output.normalize_whitespace, true
  rescue EvalIn::BadLanguageError
    m.reply "I don\'t know #{lang}.", true
  rescue EvalIn::ConnectionError
    m.reply "Failure while connecting to evaluation service.", true
  end

  match /eval$/, method: :list_languages, strip_colors: true

  def list_languages(m)
    langs = EvalIn::Result::LANGS.keys * ", "
    m.reply "Known language: #{langs}", true
  end
end
