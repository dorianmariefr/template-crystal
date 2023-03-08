class Code
  class Parser
    class ChainedCall < Operation
      def statement
        Call
      end

      def dot
        str(".")
      end

      def colon
        str(":")
      end

      def ampersand
        str("&")
      end

      def operator
        (ampersand << dot) | (colon << colon) | dot
      end
    end
  end
end
