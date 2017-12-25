# frozen_string_literal: true

#  number_facts.rb
#  Author: William Woodruff
#  -----------------------
#  Fetches a random fact about a given number from the Numbers API.
#  -----------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"

require_relative "yossarian_plugin"

class NumberFacts < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "http://numbersapi.com/%<number>d/math"

  def usage
    "!number <num> - Get a random fact about a number."
  end

  def match?(cmd)
    cmd =~ /^(!)?number$/
  end

  match /number (\d+)/, method: :number_fact

  def number_fact(m, number)
    url = URL % { number: number }
    fact = open(url).read
    m.reply fact, true
  rescue Exception => e
    m.reply e.to_s, true
  end
end
