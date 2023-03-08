class Code
  class Parser
    class Group < Language
      def code
        Code
      end

      def name
        Name
      end

      def opening_parenthesis
        str("(")
      end

      def closing_parenthesis
        str(")")
      end

      def root
        name.aka(:name) |
          (opening_parenthesis << code << closing_parenthesis.maybe).aka(:group)
      end
    end
  end
end
