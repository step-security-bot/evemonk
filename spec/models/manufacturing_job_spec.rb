# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManufacturingJob, type: :model do
  it { expect(subject).to be_an(ApplicationRecord) }

  it { expect(subject).to belong_to(:character) }
end
