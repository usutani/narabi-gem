module Narabi
  NORMAL_REGEXP = /^(?<from>.+)->(?<to>.+):\s?(?<body>.*)/
  RESPONSE_REGEXP = /^(?<from>.+)-->(?<to>.+):\s?(?<body>.*)/
  NOTE_REGEXP = /^note\s(?<from>(\s|\b|\d|\w|\W|^:)+):\s?(?<body>.*)/
  INSTANCE_REGEXP = /^instance\s?(?<name>.+)/
  INSTANCE_ALIAS_REGEXP = /^instance\s?(?<name>.+).*\sas\s(?<alias>.+)/
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

    private

    def self.create_normal(src)
      Base.try_to_create(NORMAL_REGEXP, src)
    end

    def self.create_return(src)
      msg = Base.try_to_create(RESPONSE_REGEXP, src)
      msg[:is_return] = true if msg
      msg
    end

    def self.create_note(src)
      msg = Base.try_to_create(NOTE_REGEXP, src)
      msg[:to] = msg[:from] if msg
      msg[:is_note] = true if msg
      msg
    end
  end

  class Instance
    def self.parse_line(src)
      if ins = Base.try_to_create(INSTANCE_ALIAS_REGEXP, src)
        return ins
      end
      if ins = Base.try_to_create(INSTANCE_REGEXP, src)
        return ins
      end
    end
  end

  class Diagram
    def self.parse_line(src)
      Base.try_to_create(TITLE_REGEXP, src)
    end
  end

  class Alias
    def initialize
      @aliases = {}
    end

    def parse_line_for_instance(src)
      if hash = Instance.parse_line(src)
        define_alias(hash)
      end
      hash
    end

    def parse_line_for_message(src)
      if hash = Message.parse_line(src)
        return replace_alias(hash, [:from, :to])
      end
    end

    def parse_line_for_diagram(src)
      Diagram.parse_line(src)
    end

    def self.scope
      yield Narabi::Alias.new
    end

    private

    def define_alias(hash)
      @aliases[hash[:alias]] = hash[:name]
    end

    def replace_alias(hash, keys)
      keys.each do |key|
        next unless @aliases[hash[key]]
        hash[key] = @aliases[hash[key]]
      end
      hash
    end
  end
end
