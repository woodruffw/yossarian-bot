# frozen_string_literal: true

#  jerkcity.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that fetches random Jerkcity comics for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "nokogiri"

require_relative "yossarian_plugin"

class Jerkcity < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://jerkcity.com"

  def initialize(*args)
    super
    @comic_count = 0
    initialize_comic_count
  end

  def usage
    "!jerkcity - Fetch a random comic from jerkcity.com."
  end

  def match?(cmd)
    cmd =~ /^(!)?jerkcity$/
  end

  def initialize_comic_count
    html = Nokogiri::HTML(URI.open(URL).read)
    text = html.css("div")[3].text
    @comic_count = text.split("|")[2].strip.gsub(/(No. )|(,)/, "").to_i
  rescue Exception => e
    debug e.to_s
  end

  match /jerkcity$/, method: :jerkcity

  def jerkcity(m)
    if @comic_count.positive?
      rand = Random.rand(1..@comic_count)
      comic_url = "#{URL}/_jerkcity#{rand}.html"

      begin
        html = Nokogiri::HTML(URI.open(comic_url).read)
        text_array = html.css("div")[3].text.split("|")
        comic_desc = text_array[0].strip
        comic_date = text_array[1].strip

        m.reply "#{comic_desc} (#{comic_date}) - #{comic_url}", true
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply "Internal error (couldn't get comic count)."
    end
  end
end
