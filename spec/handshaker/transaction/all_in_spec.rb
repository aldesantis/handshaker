# frozen_string_literal: true

require 'spec_helper'
require_relative './shared'

RSpec.describe Handshaker::Transaction::AllIn do
  subject { described_class.new(steps: steps) }

  let(:steps) { [buyer_step, seller_step] }
  let(:buyer_step) { Handshaker::Step::Boolean.new(party: buyer) }
  let(:seller_step) { Handshaker::Step::Boolean.new(party: seller) }
  let(:buyer_answer) { true }
  let(:seller_answer) { true }
  let(:wrong_answer) { false }
  let(:buyer) { 'buyer' }
  let(:seller) { 'seller' }

  include_examples 'transaction basics'
  include_examples 'transaction #invalid_steps and #valid'
  include_examples 'integrational'
end
