class Code
  class Parser
    class AndOperator < Operation
      def statement
        EqualityLower
      end

      def ampersand
        str("&")
      end

      def operator
        ampersand << ampersand
      end
    end
  end
end
