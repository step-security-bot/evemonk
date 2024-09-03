# frozen_string_literal: true

require "rails_helper"

RSpec.describe TermsOfServicesController do
  it { is_expected.to be_an(ApplicationController) }

  describe "#show" do
    before { get terms_of_service_path }

    context "when user not logged in" do
      it "is expected to render template show with status ok" do
        expect(response).to render_template(:show)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Terms of Service")
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "is expected to render template show with status ok" do
        expect(response).to render_template(:show)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include("Terms of Service")
      end
    end
  end
end
