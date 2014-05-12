module Customly
  class CustomlyField < ActiveRecord::Base

    #== ASSOCIATIONS
    has_many :customly_scopes
    has_many :customly_values

    #== VALIDATIONS

  end
end