# frozen_string_literal: true

require "rails_helper"

RSpec.describe Eve::System do
  it { is_expected.to be_an(ApplicationRecord) }

  it { expect(described_class.primary_key).to eq("system_id") }

  it { expect(described_class).to respond_to(:translates) }

  it { expect(described_class.mobility_attributes).to eq(["name"]) }

  it { expect(described_class.table_name).to eq("eve_systems") }

  it { is_expected.to belong_to(:constellation).optional }

  it { is_expected.to belong_to(:star).optional }

  it { is_expected.to have_many(:stargates) }

  it { is_expected.to have_many(:planets) }

  it { is_expected.to have_many(:moons) }

  it { is_expected.to have_many(:stations) }

  it { is_expected.to have_many(:asteroid_belts) }

  it { is_expected.to have_one(:position).dependent(:destroy) }

  describe "#rounded_security_status" do
    context "when security status is 0.14" do
      subject { build(:eve_system, security_status: 0.14) }

      specify { expect(subject.rounded_security_status).to eq(0.1) }
    end

    context "when security status is 0.15" do
      subject { build(:eve_system, security_status: 0.15) }

      specify { expect(subject.rounded_security_status).to eq(0.2) }
    end
  end
end
