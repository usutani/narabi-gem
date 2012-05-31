module Narabi
  NORMAL_REGEXP = /^(.+)->(.+):(.*)/
  RESPONSE_REGEXP = /^(.+)-->(.+):(.*)/

  class Sequence
    attr_reader :sender, :receiver, :message, :is_normal

    def initialize(match, is_normal = true)
      @sender, @receiver, @message = match.values_at(1..3)
      @is_normal = is_normal
    end
  end

  def self.parse_line(src)
    if match = RESPONSE_REGEXP.match(src)
      return Sequence.new(match, false)
    end
    if match = NORMAL_REGEXP.match(src)
      return Sequence.new(match)
    end
  end
end
