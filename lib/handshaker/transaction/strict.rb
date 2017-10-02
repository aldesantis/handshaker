# frozen_string_literal: true

module Handshaker
  module Transaction
    class Strict < Base
      def initialize(steps:)
        validate_steps_are_literal(steps)
        super(steps: steps)
      end

      def resolution
        nil
      end

      protected

      def validate_steps_are_literal(steps)
        if steps.find { |s| !s.is_a?(Handshaker::Step::Literal) }
          throw ArgumentError, 'all steps must be of Handshaker::Step::Literal type'
        end
      end
    end
  end
end
