# frozen_string_literal: true

require "covid19_data_ruby"
require "json"

require_relative "yossarian_plugin"

class Corona < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  BASE_URL = "https://corona.lmao.ninja/countries"

  def usage
    "!corona [country] Get the current info about corona"
  end

  def match?(cmd)
    cmd =~ /^(!)?corona/
  end

  match /corona (.+)/, method: :corona, strip_colors: true

  def corona(m, country)
    api_endpoint = "#{BASE_URL}/#{country}"
    hash = JSON.parse(URI.open(api_endpoint).read)
    m.reply "COVID-19 in #{hash["country"]} | Total: #{hash["cases"]} cases(#{hash["critical"]} critical), #{hash["deaths"]} deaths, #{hash["recovered"]} recovered. Today: #{hash["todayCases"]} cases, #{hash["todayDeaths"]} deaths.", true

  rescue OpenURI::HTTPError => e
    m.reply "Nothing found for country '#{country}'.", true
  rescue Exception => e
    m.reply e.to_s, true
  end

end
