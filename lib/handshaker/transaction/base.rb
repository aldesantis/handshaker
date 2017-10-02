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
        missing_steps.empty? && invalid_steps.empty?
      end

      def resolution
        fail NotImplementedError
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

      protected

      def validate_step(step)
        step.valid?
      end

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
