require 'spec_helper'

describe "Tag from taggable gem" do
  subject { FactoryGirl.create(:todo_item) }
  let(:tag) { FactoryGirl.create(:tag) }
  let(:tag2) { FactoryGirl.create(:tag) }
  let(:tagging) { FactoryGirl.create(:tagging, tag_id: tag.id, taggable_id: subject.id, taggable_type: "#{subject.class}") }
  let(:tagging2) { FactoryGirl.create(:tagging, tag_id: tag2.id, taggable_id: subject.id, taggable_type: "#{subject.class}") }

  context "#tag_list" do
    it "displays one tag properly" do
      tagging
      expect(subject.tag_list).to eq([tag.name])
    end

    it "displays two tags properly" do
      tagging
      tagging2
      expect(subject.tag_list).to eq(["#{tag2.name}", "#{tag.name}"])
    end
  end

  context "#tag_list=" do
    it "adds new tag to database" do
      expect {
        subject.tag_list = 'urgent'
        subject.save
      }.to change { ActsAsTaggableOn::Tag.count }.by(1)
      expect(subject.tag_list).to eq(["urgent"])
    end

    it "properly adds to database two tags given with ', '" do
      expect {
        subject.tag_list = 'urgent, fee'
        subject.save
      }.to change { ActsAsTaggableOn::Tag.count }.by(2)
      expect(subject.tag_list).to eq(["urgent", "fee"])
    end

    it "properly adds to database two tags given with ' , '" do
      expect {
        subject.tag_list = 'urgent , fee'
        subject.save
      }.to change { ActsAsTaggableOn::Tag.count }.by(2)
      expect(subject.tag_list).to eq(["urgent", "fee"])
    end

    it "properly adds to database two tags given with ','" do
      expect {
        subject.tag_list = 'urgent,fee'
        subject.save
      }.to change { ActsAsTaggableOn::Tag.count }.by(2)
      expect(subject.tag_list).to eq(["urgent", "fee"])
    end

    it "properly adds to database tag consisting of two words" do
      expect {
        subject.tag_list = 'urgent fee'
        subject.save
      }.to change { ActsAsTaggableOn::Tag.count }.by(1)
      expect(subject.tag_list).to eq(["urgent fee"])
    end

    context "with existing tag existing" do
      let!(:subject_tag) { FactoryGirl.create(:tag) }

      it "doesn't add existing tag to database if one tag given" do
        expect {
          subject.tag_list = "#{subject_tag.name}"
          subject.save
        }.to change { ActsAsTaggableOn::Tag.count }.by(0)
        expect(subject.tag_list).to eq([subject_tag.name])
      end

      it "doesn't add existing tag to database if two tags given (old one and new one)" do
        expect {
          subject.tag_list = "urgent, #{subject_tag.name}"
          subject.save
        }.to change { ActsAsTaggableOn::Tag.count }.by(1)
        expect(subject.tag_list).to eq(["urgent", "#{subject_tag.name}"])
      end
    end
  end

end
