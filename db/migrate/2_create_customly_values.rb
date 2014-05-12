class CreateCustomlyValues < ActiveRecord::Migration
  def change
    create_table :customly_values do |t|
      t.references :customly_field
      t.references :customized, polymorphic: true
      t.references :customly_scope
      t.string :value

      t.timestamps
    end
  end
end
