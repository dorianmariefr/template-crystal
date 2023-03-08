class Code
  class Parser
    class BitwiseOr < Operation
      def statement
        BitwiseAnd
      end

      def pipe
        str("|")
      end

      def caret
        str("^")
      end

      def operator
        pipe | caret
      end
    end
  end
end
