class Code
  class Parser
    class Name < Language
      def space
        str(" ")
      end

      def newline
        str("\n")
      end

      def comma
        str(",")
      end

      def equal
        str("=")
      end

      def colon
        str(":")
      end

      def opening_curly_bracket
        str("{")
      end

      def closing_curly_bracket
        str("}")
      end

      def opening_square_bracket
        str("[")
      end

      def closing_square_bracket
        str("]")
      end

      def opening_parenthesis
        str("(")
      end

      def closing_parenthesis
        str(")")
      end

      def single_quote
        str("'")
      end

      def double_quote
        str("\"")
      end

      def dot
        str(".")
      end

      def pipe
        str("|")
      end

      def ampersand
        str("&")
      end

      def plus
        str("+")
      end

      def minus
        str("-")
      end

      def asterisk
        str("*")
      end

      def exclamation_point
        str("!")
      end

      def hashtag
        str("#")
      end

      def percent
        str("%")
      end

      def caret
        str("^")
      end

      def semicolon
        str(";")
      end

      def greater
        str(">")
      end

      def lesser
        str("<")
      end

      def question_mark
        str("?")
      end

      def slash
        str("/")
      end

      def backtick
        str("`")
      end

      def tilde
        str("~")
      end

      def do_keyword
        str("do")
      end

      def end_keyword
        str("end")
      end

      def elsif_keyword
        str("elsif")
      end

      def else_keyword
        str("else")
      end

      def rescue_keyword
        str("rescue")
      end

      def ensure_keyword
        str("ensure")
      end

      def special_character
        ampersand | equal | pipe | dot | colon | comma | space | newline |
          opening_curly_bracket | closing_curly_bracket | opening_parenthesis |
          closing_parenthesis | opening_square_bracket |
          closing_square_bracket | single_quote | double_quote |
          plus | minus | asterisk | exclamation_point | hashtag |
          percent | caret | semicolon | greater | lesser |
          question_mark | slash | backtick | tilde
      end

      def character
        special_character.absent << any
      end

      def separator
        special_character | any.absent
      end

      def root
        (do_keyword << separator).absent <<
          (else_keyword << separator).absent <<
          (elsif_keyword << separator).absent <<
          (end_keyword << separator).absent <<
          (rescue_keyword << separator).absent <<
          (ensure_keyword << separator).absent <<
          character.repeat(1) <<
          (question_mark | exclamation_point).maybe
      end
    end
  end
end
