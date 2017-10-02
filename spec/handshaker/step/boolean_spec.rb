# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Boolean do
  subject { described_class.new(party: party) }

  let(:party) { 'buyer' }

  describe '#contribute' do
    describe 'boolean contribution' do
      it 'is acceptable' do
        expect { subject.contribute(true) }.not_to raise_error
      end

      it 'makes step valid' do
        subject.contribute(true)
        expect(subject).to be_valid
      end
    end

    describe 'string contribution' do
      it 'raises Handshaker::ContributionError' do
        expect { subject.contribute('answer') }.to raise_error(Handshaker::ContributionError)
      end
    end
  end
end
