# frozen_string_literal: true

RSpec.shared_examples 'step basics' do
  describe 'initializer' do
    it 'sets party' do
      expect(subject.party).to eq(party)
    end

    it 'sets contribution to nil' do
      expect(subject.contribution).to be_nil
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  describe '#contribute' do
    before { subject.contribute(contribution) }

    it 'sets contribution' do
      expect(subject.contribution).to eq(contribution)
    end

    it 'makes step contributed' do
      expect(subject).to be_contributed
    end

    it 'makes step valid' do
      expect(subject).to be_valid
    end
  end
end
