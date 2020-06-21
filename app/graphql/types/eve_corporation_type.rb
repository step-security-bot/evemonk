# frozen_string_literal: true

module Types
  class EveCorporationType < Types::BaseObject
    field :id, ID, null: false
    field :alliance, Types::EveAllianceType, null: true
    field :ceo, Types::EveCharacterType, null: true
    field :creator, Types::EveCharacterType, null: true
    field :date_founded, GraphQL::Types::ISO8601DateTime, null: true
    field :description, String, null: true
    field :faction, Types::EveFactionType, null: true
    # field :home_station, Types::EveStationType, null: true
    field :member_count, Integer, null: true
    field :name, String, null: true
    field :shares, GraphQL::Types::BigInt, null: true
    field :tax_rate, Float, null: true
    field :ticker, String, null: true
    field :url, String, null: true
    field :war_eligible, Boolean, null: true
    field :npc, Boolean, null: true
    field :characters, [Types::EveCharacterType], null: true
    # field :history
    # field :loyalty_store_offers

    def id
      object.corporation_id
    end

    def url
      object.corporation_url
    end
  end
end
