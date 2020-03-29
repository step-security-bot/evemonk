# frozen_string_literal: true

class CreateEveBlueprintManufacturingProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :eve_blueprint_manufacturing_products do |t|
      t.bigint :blueprint_id
      t.integer :quantity
      t.bigint :type_id

      t.timestamps
    end
  end
end
