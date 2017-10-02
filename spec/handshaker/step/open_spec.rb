# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Open do
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
      it 'is acceptable' do
        expect { subject.contribute('answer') }.not_to raise_error
      end

      it 'makes step valid' do
        subject.contribute('answer')
        expect(subject).to be_valid
      end
    end
  end
end
