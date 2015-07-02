#  -*- coding: utf-8 -*-
#  ip_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides IP address information lookup for yossarian-bot.
#  Uses the ipinfo.io service: https://ipinfo.io
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'resolv'
require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class IPInfo < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!ipinfo <ip> - Look up information about the given IP.'
	end

	def match?(cmd)
		cmd =~ /^(!)?ipinfo$/
	end

	match /ipinfo (.+)/, method: :ipinfo, strip_colors: true

	def ipinfo(m, ip)
		if ip =~ Resolv::IPv4::Regex || ip =~ Resolv::IPv6::Regex
			url = "http://ipinfo.io/#{URI.encode(ip)}/json"

			begin
				hash = JSON.parse(open(url).read)

				if !hash['bogon']
					host = hash['hostname'] || 'No hostname given'
					city = hash['city'] || '?'
					region = hash['region'] || '?'
					country = hash['country'] || '?'
					org = hash['org'] || '(No organization given)'

					m.reply "#{ip} (#{host}) - Owner: #{org} - City: #{city}, Region: #{region}, Country: #{country}.", true
				else
					m.reply "#{ip} is a bogon.", true
				end
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply "\'#{ip}\' is not a valid IP.", true
		end
	end
end
