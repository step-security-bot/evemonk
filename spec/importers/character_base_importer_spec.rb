# frozen_string_literal: true

require "rails_helper"

describe CharacterBaseImporter do
  let(:character_id) { double }

  subject { described_class.new(character_id) }

  describe "#initialize" do
    its(:character_id) { should eq(character_id) }
  end

  describe "#import" do
    context "when character scopes is missing scope" do
      before { expect(subject).to receive(:character_scope_present?).and_return(false) }

      specify { expect { subject.import }.not_to raise_error }
    end

    context "when character scopes includes scope" do
      before { expect(subject).to receive(:character_scope_present?).and_return(true) }

      before { expect(subject).to receive(:refresh_character_access_token) }

      before { expect(subject).to receive(:configure_middlewares) }

      before { expect(subject).to receive(:configure_esi_token) }

      before { expect(subject).to receive(:update!) }

      specify { expect { subject.import }.not_to raise_error }
    end

    context "when EveOnline::Exceptions::ResourceNotFound" do
      before { expect(subject).to receive(:character_scope_present?).and_return(true) }

      before { expect(subject).to receive(:refresh_character_access_token) }

      before { expect(subject).to receive(:configure_middlewares) }

      before { expect(subject).to receive(:configure_esi_token) }

      before { expect(subject).to receive(:update!).and_raise(EveOnline::Exceptions::ResourceNotFound) }

      before do
        #
        # Rails.logger.info("WARNING: ESI response with 404 (NOT FOUND) for Character with ID #{character_id}")
        #
        expect(Rails).to receive(:logger) do
          double.tap do |a|
            expect(a).to receive(:info).with("WARNING: ESI response with 404 (NOT FOUND) for Character with ID #{character_id}")
          end
        end
      end

      specify { expect { subject.import }.not_to raise_error }
    end

    context "when ActiveRecord::RecordNotFound" do
      before { expect(subject).to receive(:character_scope_present?).and_return(true) }

      before { expect(subject).to receive(:refresh_character_access_token) }

      before { expect(subject).to receive(:configure_middlewares) }

      before { expect(subject).to receive(:configure_esi_token) }

      before { expect(subject).to receive(:update!).and_raise(ActiveRecord::RecordNotFound) }

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

  describe "#character" do
    let(:character) { instance_double(Character) }

    context "when @character is set" do
      before { subject.instance_variable_set(:@character, character) }

      specify { expect(subject.character).to eq(character) }
    end

    context "when @character not set" do
      before do
        #
        # Character.lock.find_by!(character_id: character_id)
        #
        expect(Character).to receive(:lock) do
          double.tap do |a|
            expect(a).to receive(:find_by!).with(character_id: character_id)
              .and_return(character)
          end
        end
      end

      specify { expect(subject.character).to eq(character) }
    end
  end

  describe "#esi" do
    specify { expect { subject.esi }.to raise_error(NotImplementedError) }
  end

  describe "#update!" do
    specify { expect { subject.update! }.to raise_error(NotImplementedError) }
  end

  describe "#refresh_character_access_token" do
    context "when character scope present" do
      before { expect(subject).to receive(:character_scope_present?).and_return(true) }

      let(:character) { instance_double(Character) }

      before { expect(subject).to receive(:character).and_return(character) }

      before do
        #
        # Api::RefreshCharacterAccessToken.new(character).refresh
        #
        expect(Api::RefreshCharacterAccessToken).to receive(:new).with(character) do
          double.tap do |a|
            expect(a).to receive(:refresh)
          end
        end
      end

      specify { expect { subject.refresh_character_access_token }.not_to raise_error }
    end

    context "when character scope is not present" do
      before { expect(subject).to receive(:character_scope_present?).and_return(false) }

      specify { expect { subject.refresh_character_access_token }.not_to raise_error }
    end
  end

  describe "#character_scope_present?" do
    context "when scope present" do
      let(:esi) { double(scope: "esi-location.read_ship_type.v1") }

      before { expect(subject).to receive(:esi).and_return(esi).twice }

      let(:character) { instance_double(Character, scopes: "esi-location.read_location.v1 esi-location.read_ship_type.v1") }

      before { expect(subject).to receive(:character).and_return(character) }

      specify { expect(subject.character_scope_present?).to eq(true) }
    end

    context "when scope not present" do
      let(:esi) { double(scope: "esi-location.read_ship_type.v1") }

      before { expect(subject).to receive(:esi).and_return(esi).twice }

      let(:character) { instance_double(Character, scopes: "") }

      before { expect(subject).to receive(:character).and_return(character) }

      specify { expect(subject.character_scope_present?).to eq(false) }
    end

    context "when scope nil" do
      let(:esi) { double(scope: nil) }

      before { expect(subject).to receive(:esi).and_return(esi) }

      specify { expect(subject.character_scope_present?).to eq(true) }
    end
  end

  # private methods

  describe "#configure_middlewares" do
    let(:statistics_middleware) { double }

    let(:esi) { double }

    before { expect(subject).to receive(:statistics_middleware).and_return(statistics_middleware) }

    before { expect(subject).to receive(:esi).and_return(esi) }

    before { expect(esi).to receive(:add_middleware).and_return(statistics_middleware) }

    specify { expect { subject.send(:configure_middlewares) }.not_to raise_error }
  end

  describe "#configure_esi_token" do
    context "when esi scope present" do
      let(:esi) { double(scope: "esi-location.read_ship_type.v1") }

      before { expect(subject).to receive(:esi).and_return(esi).twice }

      let(:access_token) { double }

      let(:character) { instance_double(Character, access_token: access_token) }

      before { expect(subject).to receive(:character).and_return(character) }

      before { expect(esi).to receive(:token=).with(access_token) }

      specify { expect { subject.send(:configure_esi_token) }.not_to raise_error }
    end

    context "when esi scope blank" do
      let(:esi) { double(scope: "") }

      before { expect(subject).to receive(:esi).and_return(esi) }

      specify { expect { subject.send(:configure_esi_token) }.not_to raise_error }
    end
  end

  describe "#statistics_middleware" do
    let(:esi) { double }

    before { expect(subject).to receive(:esi).and_return(esi) }

    specify do
      expect(subject.send(:statistics_middleware)).to eq(class: StatisticsMiddleware,
                                                         esi: esi)
    end
  end
end
