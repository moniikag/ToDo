require 'spec_helper'

describe TodoItem do
  subject { FactoryGirl.create(:todo_item) }

  context ".complete" do
    it "returns proper amount of complete items" do
      expect {
        TodoItem.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      }.to change { TodoItem.complete.count }.by(1)
    end
  end

  context ".incomplete" do
    it "returns proper amount of incomplete items" do
      expect {
        TodoItem.create!(content: "Item 1", deadline: Time.now)
      }.to change{TodoItem.incomplete.count}.by(1)
    end
  end

  context "#tag_list" do
    it "displays one tag properly" do
      subject.tags.new(name: "urgent")
      expect(subject.tag_list).to eq("urgent")
    end

    it "displays two tags properly" do
      subject.tags.new(name: "urgent")
      subject.tags.new(name: "important")
      expect(subject.tag_list).to eq("urgent, important")
    end

    it "displays three tags properly" do
      subject.tags.new(name: "urgent")
      subject.tags.new(name: "important")
      subject.tags.new(name: "fee")
      expect(subject.tag_list).to eq("urgent, important, fee")
    end
  end

  context "#tag_list=" do
    it "adds new tag to database" do
      expect {
        subject.tag_list = 'urgent'
      }.to change { Tag.count }.by(1)
      expect(subject.tag_list).to eq("urgent")
    end

    it "properly adds to database two tags given with ', '" do
      expect {
        subject.tag_list = 'urgent, fee'
      }.to change { Tag.count }.by(2)
      expect(subject.tag_list).to eq("urgent, fee")
    end

    it "properly adds to database two tags given with ' , '" do
      expect {
        subject.tag_list = 'urgent , fee'
      }.to change { Tag.count }.by(2)
      expect(subject.tag_list).to eq("urgent, fee")
    end

    it "properly adds to database two tags given with ','" do
      expect {
        subject.tag_list = 'urgent,fee'
      }.to change { Tag.count }.by(2)
      expect(subject.tag_list).to eq("urgent, fee")
    end

    it "properly adds to database tag consisting of two words" do
      expect {
        subject.tag_list = 'urgent fee'
      }.to change { Tag.count }.by(1)
      expect(subject.tag_list).to eq("urgent fee")
    end

    context "with existing tag existing" do
      let!(:subject_tag) { FactoryGirl.create(:tag) }

      it "doesn't add existing tag to database if one tag given" do
        expect {
          subject.tag_list = subject_tag.name
        }.to change { Tag.count }.by(0)
        expect(subject.tag_list).to eq(subject_tag.name)
        expect(subject.tags).to include(subject_tag)
      end

      it "doesn't add existing tag to database if two tags given (old one and new one)" do
        expect {
          subject.tag_list = "urgent, #{subject_tag.name}"
        }.to change { Tag.count }.by(1)
        expect(subject.tag_list).to eq("urgent, #{subject_tag.name}")
        expect(subject.tags).to include(subject_tag)
      end
    end
  end

end
