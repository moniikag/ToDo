require 'spec_helper'

describe TagService do

  let(:todo_item) { FactoryGirl.create(:todo_item) }
  let(:tag) { FactoryGirl.create(:tag) }
  let(:other_tag) { FactoryGirl.create(:tag) }

  let(:params_all) { { todo_item: todo_item, tags: "tag1, other_tag, tag3" } }

  context "set_tag_list" do
    it "given all params sets todo item's tags" do
      expect {
        TagService.new(params_all).set_tag_list
      }.to change{ Tag.count }.by(3)
      expect(todo_item.tags.count).to eq(3)
    end

    it "given one old one new tag changes tags.count by 1" do
      todo_item.tags << tag
      expect {
        TagService.new(todo_item: todo_item, tags: "tagnew, #{tag.name}").set_tag_list
      }.to change{ Tag.count }.by(1)
    end

    it "given no tags changes todo_item.tags to 0" do
      todo_item.tags << tag
      expect(todo_item.tags.count).to eq(1)
      TagService.new(todo_item: todo_item, tags: '').set_tag_list
      expect(todo_item.tags.count).to eq(0)
    end

    it "given only tags raises an error" do
      expect {
        TagService.new(tags: "tag1, tag2, tag3").set_tag_list
      }.to raise_error(ArgumentError)
    end

    it "adds new tag to database" do
      expect {
        TagService.new(todo_item: todo_item, tags: 'urgent').set_tag_list
      }.to change { Tag.count }.by(1)
      expect(todo_item.tags).to eq(Tag.where(name: "urgent"))
    end

    it "properly adds to database two tags given with ', '" do
      expect {
        TagService.new(todo_item: todo_item, tags: 'urgent, fee').set_tag_list
      }.to change { Tag.count }.by(2)
      expect(todo_item.tags).to include(Tag.where(name: "urgent").first)
      expect(todo_item.tags).to include(Tag.where(name: "fee").first)
    end

    it "properly adds to database two tags given with ' , '" do
      expect {
        TagService.new(todo_item: todo_item, tags: 'urgent , fee').set_tag_list
      }.to change { Tag.count }.by(2)
      expect(todo_item.tags).to include(Tag.where(name: "urgent").first)
      expect(todo_item.tags).to include(Tag.where(name: "fee").first)
    end

    it "properly adds to database two tags given with ','" do
      expect {
        TagService.new(todo_item: todo_item, tags: 'urgent,fee').set_tag_list
      }.to change { Tag.count }.by(2)
      expect(todo_item.tags).to include(Tag.where(name: "urgent").first)
      expect(todo_item.tags).to include(Tag.where(name: "fee").first)
    end

    it "properly adds to database tag consisting of two words" do
      expect {
        TagService.new(todo_item: todo_item, tags: 'urgent fee').set_tag_list
      }.to change { Tag.count }.by(1)
      expect(todo_item.tags).to include(Tag.where(name: "urgent fee").first)
    end

    context "with tag already existing" do
      let!(:todo_item_tag) { FactoryGirl.create(:tag) }

      it "doesn't add existing tag to database if one tag given" do
        expect {
          TagService.new(todo_item: todo_item, tags: todo_item_tag.name).set_tag_list
        }.to change { Tag.count }.by(0)
        expect(todo_item.tags).to include(todo_item_tag)
      end

      it "doesn't add existing tag to database if two tags given (old one and new one)" do
        expect {
          TagService.new(todo_item: todo_item, tags: "urgent, #{todo_item_tag.name}").set_tag_list
        }.to change { Tag.count }.by(1)
        expect(todo_item.tags).to include(todo_item_tag)
      end
    end
  end

end

