# wikipedia.rb
# Author: slackR | slackErEhth77
# -----------
# A cinch plugin to get info from Wikipedia
# -----------
# This code is licensed by slackErEhth77 under the MIT License.
# http://opensource.org/licenses/MIT

require 'sanitize'
require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

 class Wikipedia < YossarianPlugin
        include Cinch::Plugin

        match /wiki (.+)/, method: :search_wiki

	def usage
		'!wiki <search> - Search Wikipedia. '
	end

  def search_wiki(m, search)
       query = URI.encode(search)
	     url = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&titles=#{query}&format=json&exintro=1"
       hash = JSON.parse(open(url).read)

		        if hash['query']['pages']['-1']
                             m.reply "No results for #{search}."
                    else
                             page_id = hash['query']['pages'].keys.pop()
                             content = hash['query']['pages'][page_id]['extract'].gsub(/([\t\r\n])|(<(\/)?b>)/, '')
                             content = Sanitize.fragment(content).strip()
                             content = content[0..250]
                             m.reply "#{content}..... http://enwp.org/#{query}"
		        end

          end
 end
