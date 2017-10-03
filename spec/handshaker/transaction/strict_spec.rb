# frozen_string_literal: true

require 'spec_helper'
require_relative './shared'

RSpec.describe Handshaker::Transaction::Strict do
  subject { described_class.new(steps: steps) }

  let(:steps) { [buyer_step, seller_step] }
  let(:buyer_step) { Handshaker::Step::Literal.new(party: buyer, answer: buyer_answer) }
  let(:seller_step) { Handshaker::Step::Literal.new(party: seller, answer: seller_answer) }
  let(:buyer_answer) { 1000 }
  let(:seller_answer) { 500 }
  let(:wrong_answer) { -1 }
  let(:buyer) { 'buyer' }
  let(:seller) { 'seller' }

  include_examples 'transaction basics'
  include_examples 'transaction #invalid_steps and #valid'
  include_examples 'integrational'
end
