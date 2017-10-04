# frozen_string_literal: true

module Handshaker
  module Step
    class Literal < Base
      attr_reader :answer

      def initialize(party:, answer:)
        super(party: party)
        @answer = answer
      end

      def valid?
        contribution == answer
      end
    end
  end
end
