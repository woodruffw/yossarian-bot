# frozen_string_literal: true

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class Corona < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  BASE_URL = "https://corona.lmao.ninja"

  def usage
    "!corona [location] Get the current info about corona"
  end

  def match?(cmd)
    cmd =~ /^(!)?corona/
  end

  match /corona$/, method: :corona_global, strip_colors: true

  def corona_global(m)
    corona_country(m, "World")
  end

  match /corona (.+)/, method: :corona_state, strip_colors: true

  def corona_state(m, state)
    api_endpoint = "#{BASE_URL}/v2/states/#{URI::encode(state)}"
    hash = JSON.parse(URI.open(api_endpoint).read)
    m.reply "#{hash["state"]} COVID-19 stats | #{Format(:bold, "Total:")} #{hash["cases"]} cases, #{hash["deaths"]} deaths, #{hash["tests"]} tests(#{hash["testsPerOneMillion"]} per million). #{Format(:bold, "Today:")} #{hash["todayCases"]} cases, #{hash["todayDeaths"]} deaths.", true

  rescue OpenURI::HTTPError => e
    corona_country(m, state) 
  rescue Exception => e
    m.reply e.to_s, true
  end

  def corona_country(m, country)
    api_endpoint = "#{BASE_URL}/v2/countries/#{URI::encode(country)}"
    hash = JSON.parse(URI.open(api_endpoint).read)
    m.reply "#{hash["country"]} COVID-19 stats | #{Format(:bold, "Total:")} #{hash["cases"]} cases(#{hash["critical"]} critical), #{hash["deaths"]} deaths, #{hash["recovered"]} recovered, #{hash["tests"]} tests(#{hash["testsPerOneMillion"]} per million). #{Format(:bold, "Today:")} #{hash["todayCases"]} cases, #{hash["todayDeaths"]} deaths.", true

  rescue OpenURI::HTTPError => e
    m.reply "Nothing found for location '#{country}'.", true
  rescue Exception => e
    m.reply e.to_s, true
  end

end
