require "../language"
require "./parser/whitespace"
require "./parser/code"
require "./parser/statement"
require "./parser/splat"
require "./parser/operation"
require "./parser/chained_call"
require "./parser/string"
require "./parser/number"
require "./parser/nothing"
require "./parser/name"
require "./parser/call"

class Code
  class Parser
    def initialize(input : ::String)
      @input = input
    end

    def self.parse(input)
      new(input).parse
    end

    def parse
      ::Code::Parser::Code.parse(@input)
    end
  end
end
