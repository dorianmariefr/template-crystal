class Language
  class Atom
    class Debug < Atom
      def initialize(parent : Atom | Language | Language.class)
        @parent = parent
      end

      def parse(parser)
        @parent.parse(parser)
        puts "Output: #{parser.output}"
        puts "Buffer: #{parser.buffer}"
      end

      def to_s(io)
        "#{@parent}.debug".to_s(io)
      end
    end

    class Any < Atom
      def parse(parser)
        parser.consume(1)
      end

      def to_s(io)
        "any".to_s(io)
      end
    end

    class Then < Atom
      def initialize(parent : Atom | Language | Language.class, block : Output -> Output)
        @parent = parent
        @block = block
      end

      def parse(parser)
        @parent.parse(parser)
        parser.output = @block.call(parser.output)
      end

      def to_s(io)
        "(#{@parent}).then {}".to_s(io)
      end
    end

    class Repeat < Atom
      def initialize(parent : (Atom | Language | Language.class), min : Int32 = 0, max : Int32? = nil)
        @parent = parent
        @min = min
        @max = max
      end

      def parse(parser)
        if @max.nil?
          @min.times { match(parser) }

          begin
            loop { match(parser) }
          rescue Parser::Interuption
          end
        else
          @min.times { match(parser) }

          begin
            (@max.not_nil! - @min).times { match(parser) }
          rescue Parser::Interuption
          end
        end
      end

      def to_s(io)
        min = @min.zero? ? "" : @min.to_s
        max = @max.nil? ? "" : ", #{@max}"
        parenthesis = min.empty? && max.empty? ? "" : "(#{min}#{max})"

        "(#{@parent}).repeat#{parenthesis}".to_s(io)
      end

      private def match(parser)
        clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )

        @parent.parse(clone)

        parser.cursor = clone.cursor
        parser.buffer = clone.buffer
        parser.output << clone.output
      end
    end

    class Str < Atom
      def initialize(string : String)
        @string = string
      end

      def parse(parser)
        if parser.next?(@string)
          parser.consume(@string.size)
        else
          raise Parser::Str::NotFound.new(parser, @string)
        end
      end

      def to_s(io)
        "str(#{@string.inspect})".to_s(io)
      end
    end

    class Match < Atom
      def initialize(pattern : Regex)
        @pattern = pattern
      end

      def parse(parser)
        input = parser.input[parser.cursor..]
        match = @pattern.match(input)

        if match
          parser.consume(match[0].size)
        else
          raise Parser::Match::NotFound.new(parser, @pattern)
        end
      end

      def to_s(io)
        "match(#{@pattern.inspect})".to_s(io)
      end
    end

    class Absent < Atom
      def initialize(parent : Atom | Language | Language.class)
        @parent = parent
      end

      def parse(parser)
        clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )
        @parent.parse(clone)
      rescue Parser::Interuption
      else
        raise Parser::Interuption.new(parser)
      end

      def to_s(io)
        "(#{@parent}).absent".to_s(io)
      end
    end

    class Ignore < Atom
      def initialize(parent : Atom | Language | Language.class)
        @parent = parent
      end

      def parse(parser)
        clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )
        @parent.parse(clone)
        parser.cursor = clone.cursor
      end

      def to_s(io)
        "#{@parent}.ignore".to_s(io)
      end
    end

    class Maybe < Atom
      def initialize(parent : Atom | Language | Language.class)
        @parent = parent
      end

      def parse(parser)
        clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )

        @parent.parse(clone)
      rescue Parser::Interuption
      else
        parser.buffer = clone.buffer
        parser.cursor = clone.cursor
        parser.output.merge(clone.output)
      end

      def to_s(io)
        "#{@parent}.maybe".to_s(io)
      end
    end

    class Aka < Atom
      def initialize(name : Symbol, parent : Atom | Language | Language.class)
        @name = name
        @parent = parent
      end

      def parse(parser)
        clone = Parser.new(
          root: self,
          input: parser.input,
          cursor: parser.cursor
        )

        @parent.parse(clone)

        if clone.output?
          parser.output = Output.new({@name => clone.output})
        else
          parser.output[@name] = Output.new(clone.buffer)
          parser.buffer = ""
        end

        parser.cursor = clone.cursor
      end

      def to_s(io)
        "#{@parent}.aka(#{@name.inspect})".to_s(io)
      end
    end

    class Or < Atom
      def initialize(left : Atom | Language | Language.class, right : Atom | Language | Language.class)
        @left = left
        @right = right
      end

      def parse(parser)
        left_clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )

        right_clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )

        begin
          @left.parse(left_clone)
          parser.cursor = left_clone.cursor
          parser.buffer = left_clone.buffer
          parser.output.merge(left_clone.output)
        rescue Parser::Interuption
          @right.parse(right_clone)
          parser.cursor = right_clone.cursor
          parser.buffer = right_clone.buffer
          parser.output.merge(right_clone.output)
        end
      end

      def to_s(io)
        "((#{@left}) | (#{@right}))".to_s(io)
      end
    end

    class And < Atom
      def initialize(left : Atom | Language | Language.class, right : Atom | Language | Language.class)
        @left = left
        @right = right
      end

      def parse(parser)
        @left.parse(parser)
        right_clone =
          Parser.new(
            root: self,
            input: parser.input,
            cursor: parser.cursor,
            buffer: parser.buffer
          )
        @right.parse(right_clone)
        parser.cursor = right_clone.cursor
        parser.buffer = right_clone.buffer

        parser.output.merge(right_clone.output)
      end

      def to_s(io)
        "#{@left} >> #{@right}".to_s(io)
      end
    end

    def any
      Any.new
    end

    def str(string)
      Str.new(string: string)
    end

    def absent
      Absent.new(parent: self)
    end

    def ignore
      Ignore.new(parent: self)
    end

    def maybe
      Maybe.new(parent: self)
    end

    def repeat(min = 0, max = nil)
      Repeat.new(parent: self, min: min, max: max)
    end

    def aka(name)
      Aka.new(parent: self, name: name)
    end

    def |(other)
      Or.new(left: self, right: other)
    end

    def >>(other)
      And.new(left: self, right: other)
    end

    def <<(other)
      And.new(left: self, right: other)
    end

    def then(&block : Output -> Output)
      Then.new(parent: self, block: block)
    end

    def debug
      Debug.new(parent: self)
    end

    def parse(parser)
      raise NotImplementedError.new("#{self.class}#parse")
    end

    def to_s(io)
      "".to_s(io)
    end

    def inspect(io)
      to_s(io)
    end
  end
end
