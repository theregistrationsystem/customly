module Customly
  class CustomFieldValue < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :custom_field
    belongs_to :customized, polymorphic: true

    #== VALIDATIONS
    validates :value, presence: true
    validates :customized, presence: true
    validates :custom_field, presence: true
    validate { (Customly.configuration.validations[:custom_field_value] || []).each { |blk| blk.call self } }

    delegate :label, to: :custom_field

  end
end