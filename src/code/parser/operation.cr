class Code
  class Parser
    class Operation < Language
      def statement
        raise NotImplementedError.new("#{self.class}#statement not defined")
      end

      def operator
        raise NotImplementedError.new("#{self.class}#operator not defined")
      end

      def whitespace
        Whitespace
      end

      def whitespace?
        whitespace.maybe
      end

      def root
        (
          statement.aka(:first) <<
            (
              whitespace? << operator.aka(:operator) << whitespace? <<
                statement.aka(:statement)
            ).repeat(1).aka(:others).maybe
        )
          .aka(:operation)
          .then do |output|
            if output[:operation].not_nil!.fetch(:others, nil)
              output
            else
              output[:operation].not_nil![:first].not_nil!
            end
          end
      end
    end
  end
end
