# -*- coding: utf-8 -*-
# guinea.rb
# Author: Bryan Hernandez
# -----------------------
# Display Guinea Pigs images from an imgur album
# -----------------------
#

require 'open-uri'
require 'nokogiri'

require_relative './yossarian_plugin'

class GuineaPigs < YossarianPlugin
    include Cinch::Plugin
    use_blacklist
    
    def usage
        '!guinea - Get a random guinea pig picture.'
    end

    def match?(cmd)
        cmd =~ /^(!)?guinea/
    end

    match /guinea/, method: :guinea, strip_colors: true

    def guinea(m)
        html = Nokogiri::HTML(open("http://imgur.com/r/guineapigs/").read)
        img = html.css("a[class=image-list-link]")[rand(1..60)]['href']
        m.reply "http://imgur.com#{img}", true
    end
end
