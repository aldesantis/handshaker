# frozen_string_literal: true

module Handshaker
  module Transaction
    class Base
      attr_reader :steps

      def initialize(steps:)
        validate_steps_option(steps)
        @steps = steps
      end

      def step_for(party)
        steps.find { |s| s.party == party }
      end

      def contribute_as(party, with:)
        step = step_for(party)
        fail ContributionPartyError, 'Party not found' unless step
        step.contribute(with)
      end

      def valid?
        fail NotImplementedError
      end

      def resolution
        fail NotImplementedError
      end

      protected

      def validate_steps_option(steps)
        unless steps.is_a?(Array)
          throw ArgumentError, 'steps option must be of Array type'
        end

        if steps.size < 2
          throw ArgumentError, 'steps count must be greater than 1'
        end

        if steps.find { |s| !s.is_a?(Handshaker::Step::Base) }
          throw ArgumentError, 'all steps must be of Handshaker::Step::Base type'
        end

        parties = steps.map(&:party)
        if parties.size != parties.uniq.size
          throw ArgumentError, 'no duplicate parties are allowed in steps'
        end
      end
    end
  end
end
