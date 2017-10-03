# frozen_string_literal: true

require 'spec_helper'
require_relative './shared'

RSpec.describe Handshaker::Transaction::AllOut do
  subject { described_class.new(steps: steps) }

  let(:steps) { [buyer_step, seller_step] }
  let(:buyer_step) { Handshaker::Step::Boolean.new(party: buyer) }
  let(:seller_step) { Handshaker::Step::Boolean.new(party: seller) }
  let(:buyer_answer) { false }
  let(:seller_answer) { false }
  let(:wrong_answer) { true }
  let(:buyer) { 'buyer' }
  let(:seller) { 'seller' }

  include_examples 'integrational'
end
