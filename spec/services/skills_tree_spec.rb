# frozen_string_literal: true

require "rails_helper"

describe SkillsTree do
  specify { expect(described_class::SKILLS_CATEGORY_ID).to eq(16) }

  let(:character) { instance_double(Character) }

  subject { described_class.new(character) }

  describe "#initialize" do
    its(:character) { should eq(character) }
  end

  describe "#groups" do
    context "when @groups not set" do
      let(:skills_category) { double }

      before { expect(subject).to receive(:skills_category).and_return(skills_category) }

      let(:groups) { double }

      before do
        #
        # skills_category.groups
        #                .published
        #                .includes(types: { type_dogma_attributes: :dogma_attribute })
        #                .where(dogma_attribute: {published: true})
        #                .where(types: { published: true })
        #                .order(:name_en)
        #
        expect(skills_category).to receive(:groups) do
          double.tap do |a|
            expect(a).to receive(:published) do
              double.tap do |b|
                expect(b).to receive(:includes).with(types: {type_dogma_attributes: :dogma_attribute}) do
                  double.tap do |c|
                    expect(c).to receive(:where).with(dogma_attribute: {published: true}) do
                      double.tap do |d|
                        expect(d).to receive(:where).with(types: {published: true}) do
                          double.tap do |e|
                            expect(e).to receive(:order).with(:name_en).and_return(groups)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      specify { expect { subject.groups }.not_to raise_error }

      specify { expect { subject.groups }.to change { subject.instance_variable_get(:@groups) }.from(nil).to(groups) }
    end

    context "when @groups is set" do
      let(:groups) { double }

      before { subject.instance_variable_set(:@groups, groups) }

      specify { expect(subject.groups).to eq(groups) }
    end
  end

  describe "#skills_count_in_group" do
    let!(:eve_group) { create(:eve_group, published: true) }

    let!(:eve_type1) { create(:eve_type, group: eve_group, published: false) }

    let!(:eve_type2) { create(:eve_type, group: eve_group, published: true) }

    specify { expect(subject.skills_count_in_group(eve_group)).to eq(1) }
  end

  describe "#levels_trained_in_group" do
    let!(:eve_group) { create(:eve_group, published: true) }

    let!(:eve_type1) { create(:eve_type, group: eve_group, published: false) }

    let!(:eve_type2) { create(:eve_type, group: eve_group, published: true) }

    let!(:eve_type3) { create(:eve_type, group: eve_group, published: true) }

    let!(:character) { create(:character) }

    let!(:character_skill1) do
      create(:character_skill,
        character: character,
        skill_id: eve_type1.type_id,
        trained_skill_level: 5)
    end

    let!(:character_skill2) do
      create(:character_skill,
        character: character,
        skill_id: eve_type2.type_id,
        trained_skill_level: 5)
    end

    let!(:character_skill3) do
      create(:character_skill,
        character: character,
        skill_id: eve_type3.type_id,
        trained_skill_level: 5)
    end

    specify { expect(subject.levels_trained_in_group(eve_group)).to eq(10) }
  end

  describe "#total_levels_in_group" do
    let!(:eve_group) { create(:eve_group, published: true) }

    let!(:eve_type1) { create(:eve_type, group: eve_group, published: false) }

    let!(:eve_type2) { create(:eve_type, group: eve_group, published: true) }

    let!(:eve_type3) { create(:eve_type, group: eve_group, published: true) }

    specify { expect(subject.total_levels_in_group(eve_group)).to eq(10) }
  end

  describe "#levels_in_training_queue" do
    let!(:eve_group) { create(:eve_group) }

    let!(:eve_type1) { create(:eve_type, group: eve_group, published: false) }

    let!(:eve_type2) { create(:eve_type, group: eve_group, published: true) }

    let!(:character) { create(:character) }

    let!(:skillqueue1) { create(:skillqueue, character: character, skill_id: eve_type1.type_id, finish_date: 1.day.from_now) }

    let!(:skillqueue2) { create(:skillqueue, character: character, skill_id: eve_type1.type_id, finish_date: 1.day.ago) }

    let!(:skillqueue3) { create(:skillqueue, character: character, skill_id: eve_type2.type_id, finish_date: 1.day.from_now) }

    let!(:skillqueue4) { create(:skillqueue, character: character, skill_id: eve_type2.type_id, finish_date: 1.day.ago) }

    specify { expect(subject.levels_in_training_queue(eve_group)).to eq(1) }
  end

  describe "#current_skill_points_in_group" do
    let!(:eve_group) { create(:eve_group) }

    let!(:eve_type1) { create(:eve_type, group: eve_group, published: false) }

    let!(:eve_type2) { create(:eve_type, group: eve_group, published: true) }

    let!(:eve_type3) { create(:eve_type, group: eve_group, published: true) }

    let!(:character) { create(:character) }

    let!(:character_skill1) { create(:character_skill, character: character, skill_id: eve_type1.type_id, skillpoints_in_skill: 100) }

    let!(:character_skill2) { create(:character_skill, character: character, skill_id: eve_type2.type_id, skillpoints_in_skill: 200) }

    let!(:character_skill3) { create(:character_skill, character: character, skill_id: eve_type3.type_id, skillpoints_in_skill: 300) }

    specify { expect(subject.current_skill_points_in_group(eve_group)).to eq(500) }
  end

  describe "#total_skill_points_in_group" do
    let(:eve_group) { instance_double(Eve::Group) }

    specify { expect(subject.total_skill_points_in_group(eve_group)).to eq(0) }
  end

  describe "#certificates_claimed_in_group" do
    let(:eve_group) { instance_double(Eve::Group) }

    specify { expect(subject.certificates_claimed_in_group(eve_group)).to eq(0) }
  end

  describe "#total_certificates_in_group" do
    let!(:eve_group) { create(:eve_group) }

    let!(:eve_certificate1) { create(:eve_certificate, group: eve_group) }

    let!(:eve_certificate2) { create(:eve_certificate, group: eve_group) }

    specify { expect(subject.total_certificates_in_group(eve_group)).to eq(2) }
  end

  describe "#primary_attribute_per_group" do
    let(:eve_group) { instance_double(Eve::Group) }

    before do
      #
      # group.types.published.order(:name_en).first.primary_attribute
      #
      expect(eve_group).to receive(:types) do
        double.tap do |a|
          expect(a).to receive(:published) do
            double.tap do |b|
              expect(b).to receive(:order).with(:name_en) do
                double.tap do |c|
                  expect(c).to receive(:first) do
                    double.tap do |d|
                      expect(d).to receive(:primary_attribute)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    specify { expect { subject.primary_attribute_per_group(eve_group) }.not_to raise_error }
  end

  describe "#secondary_attribute_per_group" do
    let(:eve_group) { instance_double(Eve::Group) }

    before do
      #
      # group.types.published.order(:name_en).first.secondary_attribute
      #
      expect(eve_group).to receive(:types) do
        double.tap do |a|
          expect(a).to receive(:published) do
            double.tap do |b|
              expect(b).to receive(:order).with(:name_en) do
                double.tap do |c|
                  expect(c).to receive(:first) do
                    double.tap do |d|
                      expect(d).to receive(:secondary_attribute)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    specify { expect { subject.secondary_attribute_per_group(eve_group) }.not_to raise_error }
  end

  describe "#skills_in_group" do
    let(:group) { instance_double(Eve::Group) }

    before do
      #
      # group.types.published.order(:name_en)
      #
      expect(group).to receive(:types) do
        double.tap do |a|
          expect(a).to receive(:published) do
            double.tap do |b|
              expect(b).to receive(:order).with(:name_en)
            end
          end
        end
      end
    end

    specify { expect { subject.skills_in_group(group) }.not_to raise_error }
  end

  describe "#training_rate_for_skill" do
    let!(:character) { create(:character, perception: 23, memory: 24) }

    let!(:eve_type) { create(:eve_type, published: true) }

    let!(:eve_dogma_attribute_primary) { create(:eve_dogma_attribute, name: "primaryAttribute", attribute_id: 123, published: true) }

    let!(:eve_dogma_attribute_secondary) { create(:eve_dogma_attribute, name: "secondaryAttribute", attribute_id: 124, published: true) }

    let!(:eve_type_dogma_attribute_primary) { create(:eve_type_dogma_attribute, type_id: eve_type.type_id, attribute_id: 123, value: 223) }

    let!(:eve_type_dogma_attribute_secondary) { create(:eve_type_dogma_attribute, type_id: eve_type.type_id, attribute_id: 124, value: 224) }

    let!(:eve_dogma_attribute_perception) { create(:eve_dogma_attribute, name: "perception", attribute_id: 223, published: true) }

    let!(:eve_dogma_attribute_memory) { create(:eve_dogma_attribute, name: "memory", attribute_id: 224, published: true) }

    before do
      #
      # EveOnline::Formulas::TrainingRate.new(23, 24).rate # => 35.0
      #
      expect(EveOnline::Formulas::TrainingRate).to receive(:new).with(23, 24) do
        double.tap do |a|
          expect(a).to receive(:rate).and_return(35.0)
        end
      end
    end

    specify { expect(subject.training_rate_for_skill(eve_type)).to eq("35.00") }
  end

  # private methods

  describe "#skills_category" do
    context "when @skills_category not set" do
      let(:skills_category) { double }

      before do
        #
        # Eve::Category.published
        #              .find_by!(category_id: SKILLS_CATEGORY_ID)
        #
        expect(Eve::Category).to receive(:published) do
          double.tap do |a|
            expect(a).to receive(:find_by!).with(category_id: described_class::SKILLS_CATEGORY_ID)
              .and_return(skills_category)
          end
        end
      end

      specify { expect { subject.send(:skills_category) }.not_to raise_error }

      specify { expect { subject.send(:skills_category) }.to change { subject.instance_variable_get(:@skills_category) }.from(nil).to(skills_category) }
    end

    context "when @skills_category is set" do
      let(:skills_category) { double }

      before { subject.instance_variable_set(:@skills_category, skills_category) }

      specify { expect(subject.send(:skills_category)).to eq(skills_category) }
    end
  end
end
