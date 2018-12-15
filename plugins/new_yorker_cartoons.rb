# frozen_string_literal: true

#  xkcd.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides New Yorker cartoons for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "htmlentities"

require_relative "yossarian_plugin"

class NewYorkerCartoons < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://www.newyorker.com/cartoons/random/randomAPI"

  def usage
    "!ny - Get a random New Yorker cartoon."
  end

  def match?(cmd)
    cmd =~ /^(!)?ny$/
  end

  match /ny$/, method: :random_cartoon

  def random_cartoon(m)
    comic = JSON.parse(open(URL).read).first
    caption = HTMLEntities.new.decode comic["caption"]

    if caption.empty?
      m.reply comic["src"], true
    else
      m.reply "#{caption} - #{comic["src"]}", true
    end
  rescue Exception => e
    m.reply e.to_s, true
  end
end
