class Code
  class Parser
    class IfModifier < Language
      def or_keyword_class
        OrKeyword
      end

      def if_modifier
        IfModifier
      end

      def whitespace
        Whitespace.new.without_newline
      end

      def whitespace?
        whitespace.maybe
      end

      def if_keyword
        str("if")
      end

      def unless_keyword
        str("unless")
      end

      def while_keyword
        str("while")
      end

      def until_keyword
        str("until")
      end

      def operator
        if_keyword | unless_keyword | while_keyword | until_keyword
      end

      def root
        (
          or_keyword_class.aka(:left) <<
            (
              whitespace? <<
                operator.aka(:operator) <<
                whitespace? <<
                if_modifier.aka(:right)
            ).maybe
        )
          .then do |output|
            if output.fetch(:right, nil)
              Output.new({:if_modifier => output})
            else
              output[:left].not_nil!
            end
          end
      end
    end
  end
end
