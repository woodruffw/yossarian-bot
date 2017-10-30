# frozen_string_literal: true

#  bofh_excuses.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides BOFH excuses for yossarian-bot.
#  bofh_excuses.txt adapted from Jeff Ballard's BOFH Excuse Server:
#  http://pages.cs.wisc.edu/~ballard/bofh/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class BOFHExcuses < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  EXCUSES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "bofh_excuses.txt"))
  EXCUSES = File.readlines(EXCUSES_FILE)

  def usage
    "!bofh - Fetch a random Bastard Operator From Hell excuse."
  end

  def match?(cmd)
    cmd =~ /^(!)?bofh$/
  end

  match /bofh/, method: :bofh, strip_colors: true

  def bofh(m)
    excuse = EXCUSES.sample

    m.reply excuse
  end
end
