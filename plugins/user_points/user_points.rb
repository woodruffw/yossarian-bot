#  -*- coding: utf-8 -*-
#  user_points.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides points for users for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"

require_relative "../yossarian_plugin"

class UserPoints < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @points_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, "user_points.yml"))

    if File.file?(@points_file)
      @points = YAML::load_file(@points_file)
      @points.default_proc = Proc.new { |h, k| h[k] = 0 }
    else
      FileUtils.mkdir_p File.dirname(@points_file)
      @points = Hash.new { |h, k| h[k] = 0 }
    end
  end

  def sync_points_file
    File.open(@points_file, "w+") do |file|
      file.write @points.to_yaml
    end
  end

  def usage
    "!point <command> <nick> - Give or take points away from a nickname. Commands are add, rm, and show."
  end

  def match?(cmd)
    cmd =~ /^(!)?point$/
  end

  match /point add (\S+)/, method: :add_point

  def add_point(m, nick)
    if m.user.nick != nick
      @points[nick] += 1
      m.reply "#{nick} now has #{@points[nick]} points.", true
    else
      @points[nick] -= 1
      m.reply "Nice try. You now have #{@points[nick]} points.", true
    end

    sync_points_file
  end

  match /point rm (\S+)/, method: :remove_point

  def remove_point(m, nick)
    @points[nick] -= 1
    m.reply "#{nick} now has #{@points[nick]} points.", true
    sync_points_file
  end

  match /point show (\S+)/, method: :show_intro

  def show_intro(m, nick)
    m.reply "#{nick} has #{@points[nick]} points.", true
  end

  match /point leaderboard/, method: :show_leaderboard

  def show_leaderboard(m)
    top5 = @points.max_by(5) { |_, p| p }

    leaderboard = if top5.empty?
                    "Empty"
                  else
                    top5.map { |u, p| "#{u}: #{p}" }.join ", "
                  end
    m.reply "Leaderboard: #{leaderboard}.", true
  end
end
