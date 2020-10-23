# frozen_string_literal: true

require "rails_helper"

describe Eve::AlliancesImporter do
  it { should be_a(Eve::BaseImporter) }

  describe "#import!" do
    before { expect(subject).to receive(:import_new_alliances) }

    before { expect(subject).to receive(:remove_old_alliances) }

    specify { expect { subject.import! }.not_to raise_error }
  end

  # private methods

  describe "#import_new_alliances" do
    let(:eve_alliance_ids) { double }

    before { expect(Eve::Alliance).to receive(:pluck).with(:alliance_id).and_return(eve_alliance_ids) }

    let(:alliance_ids) { double }

    let(:esi) do
      instance_double(EveOnline::ESI::Alliances,
        alliance_ids: alliance_ids)
    end

    before { expect(EveOnline::ESI::Alliances).to receive(:new).and_return(esi) }

    let(:eve_alliance_id_to_create) { double }

    let(:eve_alliance_ids_to_create) { [eve_alliance_id_to_create] }

    before { expect(alliance_ids).to receive(:-).with(eve_alliance_ids).and_return(eve_alliance_ids_to_create) }

    before { expect(Eve::UpdateAllianceJob).to receive(:perform_later).with(eve_alliance_id_to_create) }

    specify { expect { subject.send(:import_new_alliances) }.not_to raise_error }
  end

  describe "#remove_old_alliances" do
    let(:alliance_id) { double }

    let(:alliance_ids) { [alliance_id] }

    let(:esi) do
      instance_double(EveOnline::ESI::Alliances,
        alliance_ids: alliance_ids)
    end

    before { expect(EveOnline::ESI::Alliances).to receive(:new).and_return(esi) }

    let(:eve_alliance_ids) { double }

    before { expect(Eve::Alliance).to receive(:pluck).with(:alliance_id).and_return(eve_alliance_ids) }

    let(:alliance_id_to_remove) { double }

    let(:alliance_ids_to_remove) { [alliance_id_to_remove] }

    before { expect(eve_alliance_ids).to receive(:-).with(alliance_ids).and_return(alliance_ids_to_remove) }

    let(:corporation_id) { double }

    let(:corporation) { instance_double(Eve::Corporation, corporation_id: corporation_id) }

    let(:corporations) { [corporation] }

    let(:eve_alliance) { instance_double(Eve::Alliance, corporations: corporations) }

    before { expect(Eve::Alliance).to receive(:find_or_initialize_by).with(alliance_id: alliance_id_to_remove).and_return(eve_alliance) }

    before { expect(Eve::UpdateCorporationJob).to receive(:perform_later).with(corporation_id) }

    before { expect(eve_alliance).to receive(:destroy!) }

    specify { expect { subject.send(:remove_old_alliances) }.not_to raise_error }
  end
end
