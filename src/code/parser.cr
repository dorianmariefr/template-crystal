require "../language"

require "./parser/operation"

require "./parser/equality"

require "./parser/addition"
require "./parser/and_operator"
require "./parser/bitwise_and"
require "./parser/bitwise_or"
require "./parser/boolean"
require "./parser/call"
require "./parser/chained_call"
require "./parser/code"
require "./parser/dictionnary"
require "./parser/equality_lower"
require "./parser/function"
require "./parser/greater"
require "./parser/group"
require "./parser/list"
require "./parser/multiplication"
require "./parser/name"
require "./parser/negation"
require "./parser/nothing"
require "./parser/number"
require "./parser/or_operator"
require "./parser/power"
require "./parser/range"
require "./parser/rescue"
require "./parser/shift"
require "./parser/splat"
require "./parser/statement"
require "./parser/string"
require "./parser/ternary"
require "./parser/unary_minus"
require "./parser/whitespace"

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
