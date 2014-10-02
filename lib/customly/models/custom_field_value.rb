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

    concerning :Uploads do
      included do
        after_initialize def setup_attachment
          self.class.has_attached_file :attachment, (Customly.configuration.paperclip_settings[:options] || {storage: :s3,
                                                                                                             s3_credentials: 'config/s3.yml',
                                                                                                             s3_protocol: "https"})

          # Provide seperate validations for different field types

          (Customly.configuration.paperclip_settings[:validations] || []).each do |field_type, vals|
            self.class.validates_attachment_size :attachment, vals[:size].merge(if: -> (cfv) {cfv.field_type.to_sym == field_type})
            self.class.validates_attachment_content_type :attachment, vals[:content_type].merge(if: -> (cfv) {cfv.field_type.to_sym == field_type})
          end
        end

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