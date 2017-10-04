# frozen_string_literal: true

module Handshaker
  module Transaction
    class Joint < Base
      def invalid_steps
        []
      end

      def valid?
        missing_steps.empty? && all_steps_have_same_contribution?
      end

      def resolution
        valid? ? steps.first.contribution : nil
      end

      protected

      def all_steps_have_same_contribution?
        steps.map(&:contribution).uniq.size == 1
      end
    end
  end
end
