class Code
  class Parser
    class Call < Language
      def code
        Code
      end

      def code_present
        Code.new.present
      end

      def statement
        Statement
      end

      def function
        Function
      end

      def name
        Name
      end

      def whitespace
        Whitespace
      end

      def whitespace?
        whitespace.maybe
      end

      def opening_parenthesis
        str("(")
      end

      def closing_parenthesis
        str(")")
      end

      def colon
        str(":")
      end

      def equal
        str("=")
      end

      def greater
        str(">")
      end

      def comma
        str(",")
      end

      def pipe
        str("|")
      end

      def do_keyword
        str("do")
      end

      def end_keyword
        str("end")
      end

      def rescue_keyword
        str("rescue")
      end

      def else_keyword
        str("else")
      end

      def ensure_keyword
        str("ensure")
      end

      def opening_curly_bracket
        str("{")
      end

      def closing_curly_bracket
        str("}")
      end

      def keyword_argument
        (name.aka(:name) << colon << code.aka(:value)) |
          (statement.aka(:key) << whitespace? << colon << code.aka(:value)) |
          (statement.aka(:key) << whitespace? << equal << greater << code.aka(:value))
      end

      def positional_argument
        code_present.aka(:value)
      end

      def arguments
        (
          whitespace? <<
            (
              keyword_argument.aka(:keyword_argument) |
                positional_argument.aka(:positional_argument)
            ) <<
            whitespace? <<
            comma.maybe
        ).repeat(1)
      end

      def keyword_parameter
        (name.aka(:name) << colon << code.aka(:value)) |
          (statement.aka(:key) << whitespace? << colon << code.aka(:value)) |
          (statement.aka(:key) << whitespace? << equal << greater << code.aka(:value))
      end

      def positional_parameter
        name.aka(:name) << (whitespace? << equal << whitespace? << code.aka(:value)).maybe
      end

      def parameters
        (
          whitespace? <<
            (
              keyword_parameter.aka(:keyword_parameter) |
                positional_parameter.aka(:positional_parameter)
            ) <<
            whitespace? <<
            comma.maybe
        ).repeat(1)
      end

      def rescue_block
        rescue_keyword <<
          (
            whitespace? <<
              statement.aka(:class) <<
              whitespace? <<
              equal <<
              greater <<
              whitespace? <<
              statement.aka(:error)
          ).maybe <<
          code.aka(:body)
      end

      def else_block
        else_keyword <<
          code.aka(:body)
      end

      def ensure_block
        ensure_keyword <<
          code.aka(:body)
      end

      def exception_blocks
        (
          rescue_block.aka(:rescue) |
            else_block.aka(:else) |
            ensure_block.aka(:ensure)
        ).repeat(1)
      end

      def do_end_block
        do_keyword <<
          whitespace? <<
          (
            pipe <<
              whitespace? <<
              parameters.aka(:parameters) <<
              whitespace? <<
              pipe.maybe
          ).maybe <<
          code.aka(:body) <<
          exception_blocks.aka(:exceptions).maybe <<
          end_keyword.maybe
      end

      def curly_block
        opening_curly_bracket <<
          whitespace? <<
          (
            pipe <<
              whitespace? <<
              parameters.aka(:parameters) <<
              whitespace? <<
              pipe.maybe
          ).maybe <<
          code.aka(:body) <<
          exception_blocks.aka(:exceptions).maybe <<
          closing_curly_bracket.maybe
      end

      def root
        (
          function.aka(:left) << (
            (
              (
                whitespace? <<
                opening_parenthesis <<
                whitespace? <<
                arguments.aka(:arguments) <<
                whitespace? <<
                closing_parenthesis.maybe
              ) << (
                whitespace? <<
                (do_end_block | curly_block)
              ).repeat(1).aka(:blocks).maybe
            ) |
            (
              (
                whitespace? <<
                opening_parenthesis <<
                whitespace? <<
                arguments.aka(:arguments) <<
                whitespace? <<
                closing_parenthesis.maybe
              ).maybe << (
                whitespace? <<
                (do_end_block | curly_block)
              ).repeat(1).aka(:blocks)
            )
          ).repeat(1).aka(:arguments_and_blocks).maybe
        ).then do |output|
          if output.fetch(:arguments_and_blocks, nil)
            Output.new({:call => output})
          else
            output[:left].not_nil!
          end
        end
      end
    end
  end
end
