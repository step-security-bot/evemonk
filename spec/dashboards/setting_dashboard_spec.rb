# frozen_string_literal: true

require "rails_helper"

RSpec.describe SettingDashboard do
  it { expect(subject).to be_an(Administrate::BaseDashboard) }
end
