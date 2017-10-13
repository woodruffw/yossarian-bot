#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  duck_duck_go.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides DuckDuckGo interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "duck_duck_go"

require_relative "yossarian_plugin"

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
    begin
      zci = @ddg.zeroclickinfo(search)
      response = zci.abstract_text || "No results for '#{search}'."
    rescue JSON::ParserError => e
      # known bug in gem: https://github.com/andrewrjones/ruby-duck-duck-go/issues/6
      response = "No results for '#{search}'."
    end

    m.reply response, true
  end
end

