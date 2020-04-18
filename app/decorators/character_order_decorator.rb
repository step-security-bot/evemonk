# frozen_string_literal: true

class CharacterOrderDecorator < ApplicationDecorator
  decorates_associations :character, :type, :region
end
