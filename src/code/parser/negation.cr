class Code
  class Parser
    class Negation < Language
      def negation
        Negation
      end

      def whitespace
        Whitespace
      end

      def whitespace?
        whitespace.maybe
      end

      def exclamation_point
        str("!")
      end

      def tilde
        str("~")
      end

      def plus
        str("+")
      end

      def operator
        exclamation_point | tilde | plus
      end

      def root
        (operator.aka(:operator) << whitespace? << negation.aka(:right)).aka(:negation) |
          ChainedCall
      end
    end
  end
end
