# frozen_string_literal: true

require "rails_helper"

RSpec.describe Eve::Stargate, type: :model do
  it { expect(subject).to be_an(ApplicationRecord) }

  it { expect(described_class.primary_key).to eq("stargate_id") }

  it { expect(described_class.table_name).to eq("eve_stargates") }

  it { expect(subject).to belong_to(:system).optional(true) }

  it { expect(subject).to belong_to(:destination_stargate).class_name("Eve::Stargate").optional(true) }

  it { expect(subject).to belong_to(:destination_system).class_name("Eve::System").optional(true) }

  it { expect(subject).to belong_to(:type).optional(true) }

  it { expect(subject).to have_one(:position).dependent(:destroy) }
end
