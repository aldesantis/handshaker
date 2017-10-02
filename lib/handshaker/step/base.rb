# frozen_string_literal: true

module Handshaker
  module Step
    class Base
      attr_reader :party

      def initialize(party:)
        @party = party
      end
    end
  end
end
