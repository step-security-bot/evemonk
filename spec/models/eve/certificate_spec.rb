# frozen_string_literal: true

require "rails_helper"

describe Eve::Certificate do
  it { should be_an(ApplicationRecord) }

  it { should respond_to(:versions) }

  it { expect(described_class.table_name).to eq("eve_certificates") }

  it { should belong_to(:group).with_primary_key("group_id").optional(true) }

  it { should have_many(:certificate_recommended_types).dependent(:destroy) }
end
