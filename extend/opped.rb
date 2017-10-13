# frozen_string_literal: true

module Cinch
  module Plugin
    module ClassMethods
      def use_opped(silent: false)
        if silent
          hook :pre, for: [:match], method: :opped_silent?
        else
          hook :pre, for: [:match], method: :opped?
        end
      end
    end

    def opped_silent?(m)
      m.channel && m.channel.opped?(@bot.nick)
    end

    def opped?(m)
      if opped_silent?(m)
        return true
      else
        m.reply "I can\'t administrate this channel.", true
        return false
      end
    end
  end
end
