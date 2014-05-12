class CreateCustomlyFields < ActiveRecord::Migration
  def change
    create_table :customly_fields do |t|
      t.string :name                                                           
      t.string :label                                                        
      t.string :instructions             
      t.string :field_type                                         
      t.text   :possible_values                          
      t.boolean :is_required   , default: false
      t.integer :position                                            
      t.string :validation                                         
      t.string :default_value  , default: ""    
      t.references :scope, polymorphic: true
      t.boolean :editable      , default: true     
      t.timestamps
    end
  end
end
