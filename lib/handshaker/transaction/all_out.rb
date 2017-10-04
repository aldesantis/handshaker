# frozen_string_literal: true

module Handshaker
  module Transaction
    class AllOut < Base
      protected

      def validate_step(step)
        step.contribution == false
      end
    end
  end
end
