class Code
  class Parser
    class Class < Language
      def while_class
        While
      end

      def name
        Name
      end

      def code
        Code
      end

      def whitespace
        Whitespace
      end

      def whitespace?
        whitespace.maybe
      end

      def class_keyword
        str("class")
      end

      def end_keyword
        str("end")
      end

      def lesser
        str("<")
      end

      def root
        (
          class_keyword <<
            whitespace? <<
            while_class.aka(:name) <<
            (
              whitespace? <<
                lesser <<
                whitespace? <<
                while_class.aka(:superclass)
            ).maybe <<
            code.aka(:body) <<
            end_keyword.maybe
        ).aka(:class) | while_class
      end
    end
  end
end
