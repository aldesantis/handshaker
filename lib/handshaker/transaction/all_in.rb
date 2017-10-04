# frozen_string_literal: true

module Handshaker
  module Transaction
    class AllIn < Base
      protected

      def validate_step(step)
        step.contribution == true
      end
    end
  end
end
