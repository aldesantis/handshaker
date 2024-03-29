# frozen_string_literal: true

module Handshaker
  module Transaction
    class Base
      attr_reader :steps

      def initialize(steps:)
        @steps = steps
        @locked = false
      end

      def contribute_as(party, with:)
        fail TransactionLockedError if locked?
        step = step_for(party)
        fail ContributionPartyError, 'Party not found' unless step
        step.contribute(with)
      end

      def valid?
        missing_steps.empty? && invalid_steps.empty?
      end

      def resolution
        fail NotImplementedError
      end

      def locked?
        @locked
      end

      def lock!
        @locked = true
      end

      def unlock!
        @locked = false
      end

      def missing_steps
        steps.reject(&:contributed?)
      end

      def contributed_steps
        steps.select(&:contributed?)
      end

      def missing_parties
        missing_steps.map(&:party)
      end

      def invalid_steps
        contributed_steps.reject { |s| validate_step(s) }
      end

      def invalid_parties
        invalid_steps.map(&:party)
      end

      def step_for(party)
        steps.find { |s| s.party == party }
      end

      protected

      def validate_step(step)
        step.valid?
      end
    end
  end
end
