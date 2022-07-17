# frozen_string_literal: true

module Blueprints
  class TimeEfficiencyController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      @blueprint = Eve::Blueprint.blueprints.published.find(params[:id])
    end
  end
end
