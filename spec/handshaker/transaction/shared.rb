# frozen_string_literal: true

RSpec.shared_examples 'transaction basics' do
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
      it 'contributes to the correct step' do
        expect(seller_step).to receive(:contribute).with(seller_answer)
        subject.contribute_as(seller, with: seller_answer)
      end

      it 'returns contribution' do
        return_value = subject.contribute_as(seller, with: seller_answer)
        expect(return_value).to eq(seller_answer)
      end
    end

    context 'for non-existing party' do
      it 'throws ContributionPartyError' do
        expect { subject.contribute_as('foo', with: 'bar') }.to raise_error(Handshaker::ContributionPartyError)
      end
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
        expect { subject.contribute_as(buyer, with: buyer_answer) }.to raise_error(Handshaker::TransactionLockedError)
      end
    end
  end

  describe '#missing_steps' do
    it 'returns a list of not contributed steps' do
      subject.contribute_as(buyer, with: buyer_answer)
      expect(subject.missing_steps).to eq([seller_step])
    end

    it 'returns empty array when everyone contributed (no matter valid or no)' do
      subject.contribute_as(buyer, with: buyer_answer)
      subject.contribute_as(seller, with: buyer_answer)
      expect(subject.missing_steps).to eq([])
    end
  end
end

RSpec.shared_examples 'transaction #invalid_steps and #valid' do
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

  describe '#invalid_steps' do
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
        transaction.contribute_as(seller, with: wrong_answer)
        expect(transaction.invalid_steps).to eq([seller_step])
      end
    end

    context 'when there is contribution and it is valid' do
      before do
        expect(transaction).to receive(:validate_step).with(seller_step).and_return(true)
      end

      it 'returns empty array' do
        transaction.contribute_as(seller, with: seller_answer)
        expect(transaction.invalid_steps).to eq([])
      end
    end
  end
end

RSpec.shared_examples 'integrational' do
  describe 'intregrational' do
    context 'when there is no contributions' do
      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'has 2 missing steps' do
        expect(subject.missing_steps).to eq([buyer_step, seller_step])
      end

      it 'has 0 invalid steps' do
        expect(subject.invalid_steps).to eq([])
      end
    end

    context 'when there is one correct contribution' do
      before do
        subject.contribute_as(buyer, with: buyer_answer)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'has 1 missing step' do
        expect(subject.missing_steps).to eq([seller_step])
      end

      it 'has 0 invalid steps' do
        expect(subject.invalid_steps).to eq([])
      end
    end

    context 'when there is one incorrect contribution' do
      before do
        subject.contribute_as(buyer, with: wrong_answer)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'has 1 missing step' do
        expect(subject.missing_steps).to eq([seller_step])
      end

      it 'has 1 invalid step' do
        expect(subject.invalid_steps).to eq([buyer_step])
      end
    end

    context 'when there is one correct and one incorrect contribution' do
      before do
        subject.contribute_as(buyer, with: buyer_answer)
        subject.contribute_as(seller, with: wrong_answer)
      end

      it 'is invalid' do
        expect(subject).not_to be_valid
      end

      it 'has 0 missing steps' do
        expect(subject.missing_steps).to eq([])
      end

      it 'has 1 invalid step' do
        expect(subject.invalid_steps).to eq([seller_step])
      end

      context 'when we correct incorrect contribution' do
        before do
          subject.contribute_as(seller, with: seller_answer)
        end

        it 'becomes valid' do
          expect(subject).to be_valid
        end
      end
    end

    context 'when there is 2 correct contributions' do
      before do
        subject.contribute_as(buyer, with: buyer_answer)
        subject.contribute_as(seller, with: seller_answer)
      end

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'has 0 missing steps' do
        expect(subject.missing_steps).to eq([])
      end

      it 'has 0 invalid steps' do
        expect(subject.invalid_steps).to eq([])
      end
    end
  end
end
