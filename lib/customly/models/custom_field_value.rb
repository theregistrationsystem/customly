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
    validates :value, presence: true, if: -> { is_required && !supports_upload? && !customized.try(:skip_custom_field_value_validation) }
    validates :document, presence: true, if: -> { is_required && (input_type == :document_upload) && !customized.try(:skip_custom_field_value_validation) }
    validates :image, presence: true, if: -> { is_required && (input_type == :image_upload) && !customized.try(:skip_custom_field_value_validation) }

    delegate :name, :label,  :field_type, :is_required, to: :custom_field
    delegate :supports_upload?, :input_type, to: :field_type_obj

    #== ATTRIBUTES
    attr_accessor :custom_field_skope_id
    serialize :value

    #== CALLBACKS

    before_validation def reject_blank
      if self.value.is_a? Array
        self.value.reject!(&:blank?) 
      end
    end    

    before_validation def sync_raw_value
      self.raw_value = self.value
    end

    def field_type_obj
      @field_type_obj ||= FieldType.find_by_key(field_type)
    end

    concerning :Uploads do
      included do

        mount_uploader :document, Customly::DocumentUploader
        mount_uploader :image, Customly::ImageUploader

        validate def file_size
          [:document, :image].each do |f_type|
            if (f_obj = self.send(f_type)).present?
              ft = FieldType.find_by_key("#{f_type}_upload")
              limit = ft.try(:config).try(:[],:max_file_size).to_f || 1.megabyte
              if f_obj.file.size.to_f > limit
                errors.add(:base, "You cannot upload a file greater than #{limit/1.megabyte}MB")
              end
            end
          end
        end

        def value
          if supports_upload? && !value_changed?
            self.send(field_type.gsub('_upload', '')).try(:url)
          else
            self.read_attribute(:value)
          end
        end

      end
    end
    
  end
end

