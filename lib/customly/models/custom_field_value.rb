require 'carrierwave/orm/activerecord'

module Customly
  class CustomFieldValue < ActiveRecord::Base
    include Paperclip::Glue

    #== ASSOCIATIONS
    belongs_to :custom_field, inverse_of: :custom_field_values
    belongs_to :customized, polymorphic: true

    #== VALIDATIONS
    validates :customized, presence: true
    validates :custom_field, presence: true
    validate { (Customly.configuration.validations[:custom_field_value] || []).each { |blk| blk.call self } }
    validates :value, presence: true, if: -> { is_required && !customized.try(:skip_custom_field_value_validation) }

    delegate :name, :label, :input_type, :field_type, :is_required, to: :custom_field

    #== ATTRIBUTES
    attr_accessor :custom_field_skope_id
    serialize :value

    mount_uploader :document, Customly::DocumentUploader
    mount_uploader :image, Customly::ImageUploader

    concerning :Uploads do
      included do

        def value
          if FieldType.find_by_key(self.field_type).supports_upload?
            self.attachment.try(:url)
          else
            self.read_attribute(:value)
          end
        end

      end
    end
    
  end
end

