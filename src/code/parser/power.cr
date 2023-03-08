class Code
  class Parser
    class Power < Operation
      def statement
        Negation
      end

      def asterisk
        str("*")
      end

      def operator
        asterisk << asterisk
      end
    end
  end
end
