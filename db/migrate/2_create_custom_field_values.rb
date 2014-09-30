class CreateCustomFieldValues < ActiveRecord::Migration
  def change
    create_table :custom_field_values do |t|
      t.references :custom_field
      t.references :customized, polymorphic: true
      t.string :value

      t.timestamps
    end

    add_attachment :custom_field_values, :attachment

    add_index :custom_field_values, [:customized_id, :customized_type, :custom_field_id], name: "cfv_by_customized"
    
  end
end
