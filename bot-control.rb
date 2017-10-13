#!/usr/bin/env ruby
#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  start.rb
#  Author: William Woodruff
#  ------------------------
#  Starts yossarian-bot.rb using the daemons gem.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "daemons"

Daemons.run("yossarian-bot.rb")
