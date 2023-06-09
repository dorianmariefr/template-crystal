class Code
  class Parser
    class Rescue < Language
      def statement
        Statement
      end

      def ternary
        Ternary
      end

      def rescue_class
        Rescue
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

      def rescue_keyword
        str("rescue")
      end

      def equal
        str("=")
      end

      def greater
        str(">")
      end

      def root
        (
          ternary.aka(:left) <<
            (
              whitespace? <<
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
                whitespace? <<
                rescue_class.aka(:right)
            ).maybe
        )
          .then do |output|
            if output.fetch(:right, nil)
              Output.new({:rescue => output})
            else
              output[:left].not_nil!
            end
          end
      end
    end
  end
end
