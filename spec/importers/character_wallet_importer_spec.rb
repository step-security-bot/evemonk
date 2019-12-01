# frozen_string_literal: true

require "rails_helper"

describe CharacterWalletImporter do
  let(:character_id) { double }

  subject { described_class.new(character_id) }

  it { should be_a(CharacterAccessToken) }

  context "when character found" do
    let(:access_token) { double }

    let(:character) { instance_double(Character, access_token: access_token) }

    before { expect(Character).to receive(:find_by!).with(character_id: character_id).and_return(character) }

    before { expect(subject).to receive(:refresh_character_access_token) }

    let(:json) { double }

    let(:esi) do
      instance_double(EveOnline::ESI::CharacterWallet,
        as_json: json)
    end

    before { expect(EveOnline::ESI::CharacterWallet).to receive(:new).with(character_id: character_id, token: access_token).and_return(esi) }

    before { expect(character).to receive(:update!).with(json) }

    specify { expect { subject.import }.not_to raise_error }
  end

  context "when character not found (ActiveRecord::RecordNotFound)" do
    before { expect(Character).to receive(:find_by!).with(character_id: character_id).and_raise(ActiveRecord::RecordNotFound) }

    before do
      #
      # Rails.logger.info("Character with ID #{ character_id } not found")
      #
      expect(Rails).to receive(:logger) do
        double.tap do |a|
          expect(a).to receive(:info).with("Character with ID #{character_id} not found")
        end
      end
    end

    specify { expect { subject.import }.not_to raise_error }
  end
end
