# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maintenance tasks", type: :system do
  before { driven_by(:selenium_chrome_headless) }

  it "should render page" do
    visit "/maintenance_tasks"
  end
end
