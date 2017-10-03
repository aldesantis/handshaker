# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Transaction::Joint do
  subject { described_class.new(steps: steps) }

  let(:steps) { [buyer_step, seller_step] }
  let(:buyer_step) { Handshaker::Step::Open.new(party: buyer) }
  let(:seller_step) { Handshaker::Step::Open.new(party: seller) }
  let(:buyer) { 'buyer' }
  let(:seller) { 'seller' }

  describe 'integrational' do
    context 'when there is no contributions' do
      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'does not have resolution' do
        expect(subject.resolution).to be_nil
      end
    end

    context 'when there is one contribution' do
      before do
        subject.contribute_as(buyer, with: 500)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'does not have resolution' do
        expect(subject.resolution).to be_nil
      end
    end

    context 'when there is two unequal contributions' do
      before do
        subject.contribute_as(buyer, with: 500)
        subject.contribute_as(seller, with: 1000)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'does not have resolution' do
        expect(subject.resolution).to be_nil
      end

      context 'when we change them so that they become equal' do
        before do
          subject.contribute_as(buyer, with: 1000)
        end

        it 'becomes valid' do
          expect(subject).to be_valid
        end

        it 'has resolution' do
          expect(subject.resolution).to eq(1000)
        end
      end
    end
  end
end
