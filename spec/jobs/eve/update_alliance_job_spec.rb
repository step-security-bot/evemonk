# frozen_string_literal: true

require "rails_helper"

describe Eve::UpdateAllianceJob do
  it { should be_an(ApplicationJob) }

  it { expect(described_class.queue_name).to eq("default") }

  describe "#perform" do
    let(:id) { double }

    before do
      #
      # Eve::AllianceImporter.new(id).import
      #
      expect(Eve::AllianceImporter).to receive(:new).with(id) do
        double.tap do |a|
          expect(a).to receive(:import)
        end
      end
    end

    specify { expect { subject.perform(id) }.not_to raise_error }
  end
end
