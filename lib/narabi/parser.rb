module Narabi
  NORMAL_REGEXP = /^(.+)->(.+):\s?(.*)/
  RESPONSE_REGEXP = /^(.+)-->(.+):\s?(.*)/
  NOTE_REGEXP = /^note\s(.+):\s?(.*)/

  class Message
    attr_reader :sender, :receiver, :message, :is_return

    def initialize(match, is_return = false)
      @sender, @receiver, @message = match.values_at(1..3)
      @is_return = is_return
    end
  end

  def self.parse_line(src)
    if match = RESPONSE_REGEXP.match(src)
      return Message.new(match, true)
    end
    if match = NORMAL_REGEXP.match(src)
      return Message.new(match)
    end
#    if match = NOTE_REGEXP.match(src)
#      nil
#    end
  end
end
