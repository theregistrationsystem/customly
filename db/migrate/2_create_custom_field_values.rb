class CreateCustomFieldValues < ActiveRecord::Migration
  def change
    create_table :custom_field_values do |t|
      t.references :custom_field
      t.references :customized, polymorphic: true
      t.string :value

      t.timestamps
    end
  end
end
