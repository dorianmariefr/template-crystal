class Code
  class Parser
    class Code < Language
      def statement
        Statement
      end

      def whitespace
        Whitespace
      end

      def whitespace?
        whitespace.maybe
      end

      def present
        (whitespace? << statement << whitespace?).repeat(1)
      end

      def root
        (whitespace? << statement << whitespace?).repeat(1) | whitespace?
      end
    end
  end
end
