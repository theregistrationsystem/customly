class CreateCustomFieldSkopes < ActiveRecord::Migration
  def change
    create_table :custom_field_skopes do |t|
      t.references :skope, polymorphic: true
      t.references :custom_field
      t.integer :position
      t.boolean :hidden

      t.timestamps
    end
  end
end
