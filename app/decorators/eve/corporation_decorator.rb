# frozen_string_literal: true

module Eve
  class CorporationDecorator < ApplicationDecorator
    def date_founded
      object.date_founded.iso8601 if object.date_founded
    end
  end
end
