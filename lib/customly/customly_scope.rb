module Customly
  class CustomlyScope < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :customly_field
    has_many :customly_values

    #== VALIDATIONS

  end
end