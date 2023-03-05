class Language
  class Parser
    class Interuption < Exception
      def initialize(parser : Parser)
        @parser = parser
      end

      def message
        "\n#{line}#{" " * column_index}^\n"
      end

      def line
        l = input.lines[line_index]
        l += "\n" if l[-1] != "\n"
        l
      end

      def line_index
        input[...cursor].count("\n")
      end

      def column_index
        cursor - input.lines[...line_index].map(&.size).sum
      end

      def cursor
        @parser.cursor
      end

      def input
        @parser.input
      end
    end

    class Absent
      class Present < Interuption
      end
    end

    class EndOfInput < Interuption
    end

    class NotEndOfInput < Interuption
    end

    class Str
      class NotFound < Interuption
        def initialize(parser : Parser, string : String)
          @parser = parser
          @string = string
        end

        def message
          "#{@string} not found\n#{super}"
        end
      end
    end

    property root : Atom | Language | Language.class
    property input : String
    property cursor : Int32
    property buffer : String
    property output : Output

    def initialize(root, input, cursor = 0, buffer = "", output = Output.new)
      @root = root
      @input = input
      @cursor = cursor
      @buffer = buffer
      @output = output
    end

    def parse(check_end_of_input = true)
      @root.parse(self)

      if @cursor == @input.size || !check_end_of_input
        @output.present? ? @output : Output.new(@buffer)
      else
        raise NotEndOfInput.new(self)
      end
    end

    def consume(n)
      if @cursor + n <= @input.size
        @buffer += @input[@cursor, n]
        @cursor += n
      else
        raise EndOfInput.new(self)
      end
    end

    def aka(name)
      if @buffer.empty?
        @output = Output.new({name => @output})
      else
        @output[name] = Output.new(@buffer)
        @buffer = ""
      end
    end

    def next?(string)
      @input[@cursor...(@cursor + string.size)] == string
    end

    def buffer?
      @buffer != ""
    end

    def output?
      @output.present?
    end
  end
end
