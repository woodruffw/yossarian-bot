#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  guinea.rb
#  Author: Bryan Hernandez
#  -----------------------
#  Display Guinea Pigs images from an imgur album.
#  -----------------------
#  This code is licensed by Bryan Hernandez under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "nokogiri"

require_relative "./yossarian_plugin"

class GuineaPigs < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!guinea - Get a random guinea pig picture."
  end

  def match?(cmd)
    cmd =~ /^(!)?guinea$/
  end

  match /guinea$/, method: :guinea

  def guinea(m)
    html = Nokogiri::HTML(open("https://imgur.com/r/guineapigs/").read)
    img = html.css("a[class=image-list-link]")[rand(1..60)]["href"]
    m.reply "https://imgur.com#{img}", true
  end
end
