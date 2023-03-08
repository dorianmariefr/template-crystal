class Code
  class Parser
    class Addition < Operation
      def statement
        Multiplication
      end

      def plus
        str("+")
      end

      def minus
        str("-")
      end

      def operator
        plus | minus
      end
    end
  end
end
