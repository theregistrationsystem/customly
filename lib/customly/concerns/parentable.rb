module Customly
  module Parentable
    extend ActiveSupport::Concern
    included do 
    end

    module ClassMethods
      def is_customly_parent
        class_eval do
          has_many :custom_fields, as: :parent, :dependent => :destroy, class_name: "Customly::CustomField"
          has_many :custom_field_skopes, through: :custom_fields, class_name: "Customly::CustomFieldSkope"
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Customly::Parentable