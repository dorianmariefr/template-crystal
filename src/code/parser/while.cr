class Code
  class Parser
    class While < Language
      def if_class
        If
      end

      def whitespace
        Whitespace
      end

      def code
        Code
      end

      def while_keyword
        str("while")
      end

      def until_keyword
        str("until")
      end

      def end_keyword
        str("end")
      end

      def root
        (
          (while_keyword | until_keyword).aka(:operator) << whitespace <<
            if_class.aka(:statement) << code.aka(:body) << end_keyword.maybe
        ).aka(:while) | if_class
      end
    end
  end
end
