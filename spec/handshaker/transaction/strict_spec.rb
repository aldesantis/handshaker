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

  describe 'initialization' do
    describe 'steps: param validation' do
      it 'throws ArgumentError when steps are not Step::Literal' do
        steps = [Handshaker::Step::Open.new(party: buyer), Handshaker::Step::Boolean.new(party: seller)]
        expect { described_class.new(steps: steps) }.to raise_error(ArgumentError)
      end
    end
  end

  include_examples 'integrational'
end
