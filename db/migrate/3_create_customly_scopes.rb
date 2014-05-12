class CreateCustomlyScopes < ActiveRecord::Migration
  def change
    create_table :customly_scopes do |t|
      t.references :scope, polymorphic: true
      t.integer :position
      t.boolean :hidden

      t.timestamps
    end
  end
end
