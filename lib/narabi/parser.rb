module Narabi
  NORMAL_REGEXP = /^(?<from>.+)->(?<to>.+):\s?(?<body>.*)/
  RESPONSE_REGEXP = /^(?<from>.+)-->(?<to>.+):\s?(?<body>.*)/
  NOTE_REGEXP = /^note\s(?<from>(\s|\b|\d|\w|\W|^:)+):\s?(?<body>.*)/
  INSTANCE_REGEXP = /^instance\s?(?<name>.+)/
  TITLE_REGEXP = /^title\s(?<title>.+)/

  class Base
    def self.try_to_create(regexp, src)
      return nil unless match = regexp.match(src)
      indexes = regexp.named_captures
      hash = {}
      regexp.names.each do |name|
        hash[name.to_sym] = match[indexes[name].first]
      end
      hash
    end
  end

  class Message
    def self.create_normal(src)
      msg = Base.try_to_create(NORMAL_REGEXP, src)
      #msg[:is_return] = false if msg
      #msg[:is_note] = false if msg
      msg
    end

    def self.create_return(src)
      msg = Base.try_to_create(RESPONSE_REGEXP, src)
      msg[:is_return] = true if msg
      #msg[:is_note] = false if msg
      msg
    end

    def self.create_note(src)
      msg = Base.try_to_create(NOTE_REGEXP, src)
      msg[:to] = msg[:from] if msg
      #msg[:is_return] = false if msg
      #msg[:to] = "" if msg
      msg[:is_note] = true if msg
      msg
    end
  end

  class Instance
    def self.parse_line(src)
      msg = Base.try_to_create(INSTANCE_REGEXP, src)
    end
  end

  class Diagram
    def self.parse_line(src)
      msg = Base.try_to_create(TITLE_REGEXP, src)
    end
  end

  def self.parse_line(src)
    if msg = Message.create_return(src)
      return msg
    end
    if msg = Message.create_normal(src)
      return msg
    end
    if msg = Message.create_note(src)
      return msg
    end
  end
end
