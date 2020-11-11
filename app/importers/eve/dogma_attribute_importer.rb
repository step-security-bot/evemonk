# frozen_string_literal: true

module Eve
  class DogmaAttributeImporter < BaseImporter
    attr_reader :attribute_id

    def initialize(attribute_id)
      @attribute_id = attribute_id
    end

    def import!
      eve_dogma_attribute = Eve::DogmaAttribute.find_or_initialize_by(attribute_id: attribute_id)

      eve_dogma_attribute.update!(esi.as_json)
    rescue EveOnline::Exceptions::ResourceNotFound
      eve_dogma_attribute.destroy!
    end

    def esi
      @esi ||= EveOnline::ESI::DogmaAttribute.new(id: attribute_id)
    end
  end
end
