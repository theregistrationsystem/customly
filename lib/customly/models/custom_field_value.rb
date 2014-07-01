module Customly
  class CustomFieldValue < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :custom_field
    belongs_to :customized, polymorphic: true

    #== VALIDATIONS
    validates :customized, presence: true
    validates :custom_field, presence: true
    validate { (Customly.configuration.validations[:custom_field_value] || []).each { |blk| blk.call self } }

    delegate :label, :input_type, :field_type, to: :custom_field

    #== ATTRIBUTES
    attr_accessor :custom_field_skope_id
  end
end