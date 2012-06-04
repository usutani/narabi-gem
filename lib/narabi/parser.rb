module Narabi
  NORMAL_REGEXP = /^(.+)->(.+):\s?(.*)/
  RESPONSE_REGEXP = /^(.+)-->(.+):\s?(.*)/
  NOTE_REGEXP = /^note\s(.+):\s?(.*)/

  class Message
    attr_reader :from, :to, :body, :is_return, :is_note

    def initialize(match, is_return = false, is_note = false)
      @from, @to, @body = match.values_at(1..3)
      @is_return = is_return
      @is_note = is_note
    end

    def self.create_normal(match)
      return Message.new(match)
    end

    def self.create_return(match)
      return Message.new(match, true)
    end

    def self.create_note(match)
      return Message.new(match, false, true)
    end
  end

  def self.parse_line(src)
    if match = RESPONSE_REGEXP.match(src)
      return Message.create_return(match)
    end
    if match = NORMAL_REGEXP.match(src)
      return Message.create_normal(match)
    end
#    if match = NOTE_REGEXP.match(src)
#      nil
#    end
  end
end
