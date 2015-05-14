require 'spec_helper'

describe TodoList do
  subject { FactoryGirl.create(:todo_list) }

  context '#has_completed_items?' do
    it 'returns true if todo_list has only completed items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      expect(subject.has_completed_items?).to eq(true)
    end

    it 'returns true if todo_list has completed and incomplete items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      subject.todo_items.create!(content: "Item 2", deadline: Time.now, completed_at: nil)
      expect(subject.has_completed_items?).to eq(true)
    end

    it 'returns false if todo_list has no items' do
      expect(subject.todo_items.count).to eq(0)
      expect(subject.has_completed_items?).to eq(false)
    end

    it 'returns false if todo_list has only incomplete items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: nil)
      expect(subject.todo_items.count).to eq(1)
      expect(subject.has_completed_items?).to eq(false)
    end
  end

  context '#has_incomplete_items?' do
    it 'returns true if todo_list has only incomplete items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: nil)
      expect(subject.has_incomplete_items?).to eq(true)
    end

    it 'returns true if todo_list has completed and incomplete items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      subject.todo_items.create!(content: "Item 2", deadline: Time.now, completed_at: nil)
      expect(subject.has_incomplete_items?).to eq(true)
    end

    it 'returns false if todo_list has no items' do
      expect(subject.todo_items.count).to eq(0)
      expect(subject.has_incomplete_items?).to eq(false)
    end

    it 'returns false if todo_list has only completed items' do
      subject.todo_items.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      expect(subject.todo_items.count).to eq(1)
      expect(subject.has_incomplete_items?).to eq(false)
    end
  end

end
