# frozen_string_literal: true

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
