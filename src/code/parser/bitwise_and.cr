class Code
  class Parser
    class BitwiseAnd < Operation
      def statement
        Shift
      end

      def ampersand
        str("&")
      end

      def operator
        ampersand
      end
    end
  end
end
