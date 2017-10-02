# frozen_string_literal: true

module Handshaker
  module Step
    class Base
      attr_reader :party
      attr_reader :contribution

      def initialize(party:)
        @party = party
        @contibution = nil
      end

      def contribute(contribution)
        @contribution = contribution
      end

      def contributed?
        !contribution.nil?
      end

      def valid?
        contributed?
      end
    end
  end
end
