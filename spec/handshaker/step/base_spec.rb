# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Handshaker::Step::Base do
  describe 'constructor' do
    subject { described_class.new(party: party) }

    let(:party) { 'buyer' }

    it 'sets party' do
      expect(subject.party).to eq(party)
    end
  end
end
