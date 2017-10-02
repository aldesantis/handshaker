# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Base do
  subject { described_class.new(party: party) }

  let(:party) { 'buyer' }

  describe 'initializer' do
    it 'sets party' do
      expect(subject.party).to eq(party)
    end

    it 'sets contribution to nil' do
      expect(subject.contribution).to be_nil
    end
  end

  describe '#contribute' do
    let(:contribution) { 100 }

    before { subject.contribute(contribution) }

    it 'sets contribution' do
      expect(subject.contribution).to eq(contribution)
    end

    it 'makes step contributed' do
      expect(subject).to be_contributed
    end
  end
end
