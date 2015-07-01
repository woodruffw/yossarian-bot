#  -*- coding: utf-8 -*-
#  github_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets information about a user or repository from GitHub.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class GitHubInfo < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!gh <query> - Get information about a user or repository on GitHub. Alias: !github.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(github)|(gh)$/
	end

	match /gh (\S+)/, method: :github_info, strip_colors: true
	match /github (\S+)/, method: :github_info, strip_colors: true

	def github_info(m, query)
		if query.include?('/')
			user, repo = query.split('/')
			github_repo_info(m, user, repo)
		else
			github_user_info(m, query)
		end
	end

	def github_user_info(m, user)
		url = "https://api.github.com/users/#{URI.encode(user)}"

		begin
			hash = JSON.parse(open(url).read)

			if hash.has_key?('login')
				login = hash['login']
				name = hash['name'] || 'No name given'
				repos = hash['public_repos']
				followers = hash['followers']
				following = hash['following']
				m.reply "#{login} (#{name}) has #{repos} repositories, #{followers} followers, and is following #{following} people. See more at https://github.com/#{login}", true
			else
				m.reply "No such user \'#{user}\'.", true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end

	def github_repo_info(m, user, repo)
		url = "https://api.github.com/repos/#{URI.encode(user)}/#{URI.encode(repo)}"

		begin
			hash = JSON.parse(open(url).read)

			repo = hash['name']
			desc = hash['description']
			forks = hash['forks_count']
			stars = hash['stargazers_count']
			watchers = hash['watchers_count']
			open_issues = hash['open_issues_count']
			link = hash['html_url']

			m.reply "#{repo} - #{desc} (#{forks} forks, #{stars} stars, #{watchers} watchers, #{open_issues} open issues) See more at #{link}", true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
