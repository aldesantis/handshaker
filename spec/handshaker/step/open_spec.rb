# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Open do
  subject { described_class.new(party: party) }

  let(:party) { 'buyer' }

  describe '#contribute' do
    before { subject.contribute(contribution) }

    describe 'boolean contribution' do
      let(:contribution) { true }

      it 'is acceptable' do
        expect(subject.contribution).to eq(contribution)
      end

      it 'makes step valid' do
        expect(subject).to be_valid
      end
    end

    describe 'string contribution' do
      let(:contribution) { 'foo' }

      it 'is acceptable' do
        expect(subject.contribution).to eq(contribution)
      end

      it 'makes step valid' do
        expect(subject).to be_valid
      end
    end
  end
end
