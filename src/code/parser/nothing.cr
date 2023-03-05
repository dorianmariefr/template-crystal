class Code
  class Parser
    class Nothing < Language
      def nothing_keyword
        str("nothing")
      end

      def nil_keyword
        str("nil")
      end

      def null_keyword
        str("null")
      end

      def undefined_keyword
        str("undefined")
      end

      def root
        (nothing_keyword | nil_keyword | null_keyword | undefined_keyword).aka(:nothing) |
          Call
      end
    end
  end
end
