require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attrbutes' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'is invalid without title' do
      task = build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task = build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with a duplicate title' do
      create(:task)
      task = build(:task)
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    it 'is valid with another title' do
      create(:task)
      task = build(:task, title: 'sample02')
      expect(task).to be_valid
    end
  end
end
