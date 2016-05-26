class AddCustomFieldIdIndexToCustomFieldValues < ActiveRecord::Migration
  def change
    add_index :custom_field_values, :custom_field_id, name: "cfv_custom_field_id"
  end
end
