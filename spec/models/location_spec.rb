require 'rails_helper'

RSpec.describe Location, type: :model do
  subject {build(:location)}
  # subject { described_class.new(
  #   name: 'Test Location',
  #   tagline: 'dkajsncjadns',
  #   description: 'hello'
  # )}
  
  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a tagline' do
      subject.tagline = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end
end

