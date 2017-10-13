#  -*- coding: utf-8 -*-
#  cstopic.rb
#  Author: slackR
#  ------------------------
#  A Cinch plugin that generates CS research topics for yossarian-bot.
#  ------------------------
#  This code is licensed by slackR under the MIT License.
#  http://opensource.org/licenses/MIT

require "research_topicgen"

require_relative "yossarian_plugin"

class CSTopics < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!topic <cs|system|crypto> - Generate worthy research topics."
  end

  match /topic (.+)/, method: :topic

  def match?(cmd)
    cmd =~ /^(!)?topic$/
  end

  def topic(m, search)
    if search =~ /cs/
      m.reply ResearchTopicGen.cs, true
    elsif search =~ /system/
      m.reply ResearchTopicGen.system, true
    elsif search =~ /crypto/
      m.reply ResearchTopicGen.crypto, true
    elsif search =~ /random/
      m.reply ResearchTopicGen.send([:cs, :system, :crypto].sample), true
    else
      m.reply "Research Topics for #{topic} can't be generated.", true
    end
  end
end
