# frozen_string_literal: true

module Handshaker
  module Step
    class Boolean < Base
      def contribute(contribution)
        if contribution == true || contribution == false
          super(contribution)
        else
          fail ContributionValueError, 'Boolean contribution is expected'
        end
      end
    end
  end
end
