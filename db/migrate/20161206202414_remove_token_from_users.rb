# frozen_string_literal: true

class RemoveTokenFromUsers < ActiveRecord::Migration[5.0]
  def change
    safety_assured { remove_column :users, :token, :string }
  end
end
