# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Transaction::Base do
  subject { described_class.new(steps: steps) }

  let(:steps) { [buyer_step, seller_step] }
  let(:buyer_step) { Handshaker::Step::Open.new(party: buyer) }
  let(:seller_step) { Handshaker::Step::Open.new(party: seller) }
  let(:buyer) { 'buyer' }
  let(:seller) { 'seller' }

  describe 'initialization' do
    it 'sets steps' do
      expect(subject.steps).to eq(steps)
    end
  end

  describe '#step_for' do
    context 'for existing party' do
      it 'returns correct step' do
        expect(subject.step_for(seller)).to eq(seller_step)
      end
    end

    context 'for non-existing party' do
      it 'returns nil' do
        expect(subject.step_for('foo')).to be_nil
      end
    end
  end

  describe '#contribute_as' do
    context 'for existing party' do
      let(:contribution) { 'bar' }

      it 'contributes to the correct step' do
        expect(seller_step).to receive(:contribute).with(contribution)
        subject.contribute_as(seller, with: contribution)
      end

      it 'returns contribution' do
        return_value = subject.contribute_as(seller, with: contribution)
        expect(return_value).to eq(contribution)
      end
    end

    context 'for non-existing party' do
      it 'throws ContributionPartyError' do
        expect { subject.contribute_as('foo', with: 'bar') }.to raise_error(Handshaker::ContributionPartyError)
      end
    end
  end

  describe '#missing_steps' do
    it 'returns a list of not contributed steps' do
      subject.contribute_as(buyer, with: 'foo')
      expect(subject.missing_steps).to eq([seller_step])
    end

    it 'returns empty array when everyone contributed (no matter valid or no)' do
      subject.contribute_as(buyer, with: 'foo')
      subject.contribute_as(seller, with: 'bar')
      expect(subject.missing_steps).to eq([])
    end
  end

  describe 'invalid_steps' do
    let(:transaction) { described_class.new(steps: steps) }

    context 'when there is no contributions' do
      it 'returns an empty array' do
        expect(transaction.invalid_steps).to eq([])
      end
    end

    context 'when there is contribution and it is invalid' do
      before do
        expect(transaction).to receive(:validate_step).with(seller_step).and_return(false)
      end

      it 'returns the step' do
        transaction.contribute_as(seller, with: 'wrong value')
        expect(transaction.invalid_steps).to eq([seller_step])
      end
    end

    context 'when there is contribution and it is valid' do
      before do
        expect(transaction).to receive(:validate_step).with(seller_step).and_return(true)
      end

      it 'returns empty array' do
        transaction.contribute_as(seller, with: 'correct value')
        expect(transaction.invalid_steps).to eq([])
      end
    end
  end

  describe '#valid?' do
    let(:transaction) { described_class.new(steps: steps) }

    context 'when there are missing steps' do
      it 'returns false' do
        allow(transaction).to receive(:missing_steps).and_return([seller_step])
        allow(transaction).to receive(:invalid_steps).and_return([])
        expect(transaction.valid?).to be_falsy
      end
    end

    context 'when there are invalid steps' do
      it 'returns false' do
        allow(transaction).to receive(:missing_steps).and_return([])
        allow(transaction).to receive(:invalid_steps).and_return([seller_step])
        expect(transaction.valid?).to be_falsy
      end
    end

    context 'when there are no invalid or missing steps' do
      it 'returns false' do
        allow(transaction).to receive(:missing_steps).and_return([])
        allow(transaction).to receive(:invalid_steps).and_return([])
        expect(transaction.valid?).to be_truthy
      end
    end
  end

  describe '#resolution' do
    it 'is not implemented in base class' do
      expect { subject.resolution }.to raise_error(NotImplementedError)
    end
  end

  describe 'transaction locking' do
    it 'is unlocked by default' do
      expect(subject).not_to be_locked
    end

    describe '#lock!' do
      it 'locks transaction' do
        subject.lock!
        expect(subject).to be_locked
      end
    end

    describe '#unlock!' do
      it 'unlocks transaction' do
        subject.lock!
        subject.unlock!
        expect(subject).not_to be_locked
      end
    end

    describe 'contributing to locked transaction' do
      it 'will raise TransactionLockedError' do
        subject.lock!
        expect { subject.contribute_as(buyer, with: 1000) }.to raise_error(Handshaker::TransactionLockedError)
      end
    end
  end
end
