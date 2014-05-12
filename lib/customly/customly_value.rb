module Customly
  class CustomlyValue < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :customly_field
    belongs_to :customly_scope
    belogns_to :customized, polymorphic: true

    #== VALIDATIONS



  end
end