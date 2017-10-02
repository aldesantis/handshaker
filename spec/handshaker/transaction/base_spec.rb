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

    describe 'steps: param validation' do
      it 'throws ArgumentError when it is not array' do
        expect { described_class.new(steps: 1) }.to raise_error(ArgumentError)
      end

      it 'throws ArgumentError when there is only one step' do
        steps = [buyer_step]
        expect { described_class.new(steps: steps) }.to raise_error(ArgumentError)
      end

      it 'throws ArgumentError when not all members are Step' do
        steps = [buyer_step, Object.new]
        expect { described_class.new(steps: steps) }.to raise_error(ArgumentError)
      end

      it 'throws ArgumentError when it contais steps with duplicate members' do
        steps = [buyer_step, buyer_step]
        expect { described_class.new(steps: steps) }.to raise_error(ArgumentError)
      end
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

  describe 'valid?' do
    it 'is not implemented in base class' do
      expect { subject.valid? }.to raise_error(NotImplementedError)
    end
  end

  describe 'resolution' do
    it 'is not implemented in base class' do
      expect { subject.resolution }.to raise_error(NotImplementedError)
    end
  end
end
