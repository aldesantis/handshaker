# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Literal do
  subject { described_class.new(party: party, answer: answer) }

  let(:party) { 'buyer' }
  let(:answer) { '42' }

  describe '#contribute' do
    describe 'boolean contribution' do
      it 'is acceptable' do
        expect { subject.contribute(true) }.not_to raise_error
      end
    end

    describe 'other type contribution' do
      it 'is acceptable' do
        expect { subject.contribute(Object.new) }.not_to raise_error
      end
    end

    context 'when correct answer is contributed' do
      it 'is valid' do
        subject.contribute(answer)
        expect(subject).to be_valid
      end
    end

    context 'when wrong answer is contributed' do
      it 'is not valid' do
        subject.contribute(777)
        expect(subject).not_to be_valid
      end
    end
  end
end
