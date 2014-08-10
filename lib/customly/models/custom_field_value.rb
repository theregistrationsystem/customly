module Customly
  class CustomFieldValue < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :custom_field, inverse_of: :custom_field_values
    belongs_to :customized, polymorphic: true

    #== VALIDATIONS
    validates :customized, presence: true
    validates :custom_field, presence: true
    validate { (Customly.configuration.validations[:custom_field_value] || []).each { |blk| blk.call self } }
    validates :value, presence: true, unless: -> { !is_required || customized.try(:skip_custom_field_value_presence_validation) }

    delegate :name, :label, :input_type, :field_type, :is_required, to: :custom_field

    #== ATTRIBUTES
    attr_accessor :custom_field_skope_id
    serialize :value

  end
end