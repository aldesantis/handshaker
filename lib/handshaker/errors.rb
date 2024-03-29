# frozen_string_literal: true

module Handshaker
  class ContributionValueError < StandardError; end
  class ContributionPartyError < StandardError; end
  class TransactionLockedError < StandardError; end
end
