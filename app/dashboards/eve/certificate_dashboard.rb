# frozen_string_literal: true

require "administrate/base_dashboard"

module Eve
  class CertificateDashboard < Administrate::BaseDashboard
    ATTRIBUTE_TYPES = {
      id: Field::Number,
      name: Field::String,
      description: Field::Text,
      group: Field::BelongsTo,
      created_at: Field::DateTime,
      updated_at: Field::DateTime
    }.freeze

    COLLECTION_ATTRIBUTES = [:id, :name].freeze

    SHOW_PAGE_ATTRIBUTES = [
      :id,
      :name,
      :description,
      :group,
      :created_at,
      :updated_at
    ].freeze

    COLLECTION_FILTERS = {}.freeze

    def display_resource(certificate)
      certificate.name
    end
  end
end
