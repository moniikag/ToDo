require 'spec_helper'

describe TagService do

  let(:todo_item) { FactoryGirl.create(:todo_item) }
  let(:tag) { FactoryGirl.create(:tag) }
  let(:other_tag) { FactoryGirl.create(:tag) }

  let(:params_all) { { todo_item: todo_item, tags: "tag1, other_tag, tag3" } }

  context "tag_list" do
    it "given todo_item displays todo_items tag_list" do
      todo_item.tags << tag
      todo_item.tags << other_tag
      expect(TagService.new(todo_item: todo_item).tag_list).to eq("#{tag.name}, #{other_tag.name}")
    end

    it "given extra params displays todo_item tag_list properly" do
      todo_item.tags << tag
      todo_item.tags << other_tag
      expect(TagService.new(params_all).tag_list).to eq("#{tag.name}, #{other_tag.name}")
    end

    it "not given todo_item raises an error" do
      expect {
        TagService.new().tag_list
      }.to raise_error(ArgumentError)
    end
  end

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
  end

end
