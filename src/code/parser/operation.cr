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
          .then do |output|
            if output.fetch(:others, nil)
              Output.new({:operation => output})
            else
              output[:first].not_nil!
            end
          end
      end
    end
  end
end
