module Customly
  class CustomFieldSkope < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :custom_field
    belongs_to :skope, polymorphic: true

    #== VALIDATIONS
    validate { (Customly.configuration.validations[:custom_field_skope] || []).each { |blk| blk.call self } }

  end
end