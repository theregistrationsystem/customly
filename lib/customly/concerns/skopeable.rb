module Customly
  module Skopeable
    extend ActiveSupport::Concern
    included do 
    end

    module ClassMethods
      def is_customly_skope
        class_eval do
          has_many :custom_field_skopes, as: :skope, :dependent => :destroy, class_name: "Customly::CustomFieldSkope"
          has_many :custom_fields, through: :custom_field_skopes, class_name: "Customly::CustomField"
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Customly::Skopeable