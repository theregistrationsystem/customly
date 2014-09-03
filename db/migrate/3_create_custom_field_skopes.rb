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

  add_index :custom_field_skopes, [:custom_field_id]
  add_index :custom_field_skopes, [:skope_type, :skope_id, :custom_field_id], name: "custom_field_skoped_lookup"

end
