class Code
  class Parser
    class Function < Language
      def name
        Name
      end

      def code
        Code
      end

      def code_present
        Code.new.present
      end

      def whitespace
        Whitespace
      end

      def statement
        Statement
      end

      def whitespace?
        whitespace.maybe
      end

      def opening_parenthesis
        str("(")
      end

      def closing_parenthesis
        str(")")
      end

      def colon
        str(":")
      end

      def comma
        str(",")
      end

      def equal
        str("=")
      end

      def greater
        str(">")
      end

      def opening_curly_bracket
        str("{")
      end

      def closing_curly_bracket
        str("}")
      end

      def keyword_parameter
        (name.aka(:name) << whitespace? << colon << code_present.aka(:value).maybe) |
          (statement.aka(:key) << colon << code_present.aka(:value).maybe) |
          (
            statement.aka(:key) <<
              whitespace? <<
              equal <<
              greater <<
              code_present.aka(:value).maybe
          )
      end

      def positional_parameter
        name.aka(:name) << whitespace? <<
          (equal << whitespace? << code.aka(:value)).maybe
      end

      def parameter
        keyword_parameter.aka(:keyword_parameter) |
          positional_parameter.aka(:positional_parameter)
      end

      def parameters
        opening_parenthesis.ignore << whitespace? <<
          (whitespace? << parameter << whitespace? << comma.maybe).repeat <<
          whitespace? << closing_parenthesis.ignore.maybe
      end

      def root
        (
          parameters.aka(:parameters) << whitespace? << equal << greater <<
            whitespace? << opening_curly_bracket << code.aka(:body) <<
            closing_curly_bracket.maybe
        ).aka(:function) | Dictionnary
      end
    end
  end
end
