module Customly
  module Customizable
    extend ActiveSupport::Concern

    module ClassMethods
      def is_customizable
        return if self.included_modules.include?(Customizable::InstanceMethods)
        send :include, Customizable::InstanceMethods

        class_eval do
          has_many :custom_field_values, as: :customized, :dependent => :destroy, class_name: "Customly::CustomFieldValue"

          accepts_nested_attributes_for :custom_field_values

        end
      end
    end

    module InstanceMethods

      def available_custom_fields(skopes, show_private: false)
        wc = skopes.map {|s| "(custom_field_skopes.skope_type = '#{s.class.to_s}' AND custom_field_skopes.skope_id = #{s.id})"}.join(' OR ')
        fields = Customly::CustomField.joins(:custom_field_skopes)
                                      .select("custom_fields.*, custom_field_skopes.id as custom_field_skope_id")
                                      .where(wc)
        fields = fields.where(private: false) unless show_private
      end
      
      def find_or_build_custom_field_values(skopes, show_private: false)
        find_or__custom_field_values(:build, skopes, show_private: false)
      end

      def find_or_create_custom_field_values!(skopes, show_private: false)
        find_or__custom_field_values(:create, skopes, show_private: false)
      end

      private

      def find_or__custom_field_values(action, skopes, show_private: false)
        available_custom_fields(skopes, show_private: show_private).map do |cf|
          cfv = (custom_field_values.includes(:custom_field).detect { |v| v.custom_field == cf } ||
                 custom_field_values.send(action, :customized => self, :custom_field => cf, :value => cf.default_value))
          cfv.custom_field_skope_id = cf.custom_field_skope_id
          cfv
        end
      end
      
    end
  end
end

ActiveRecord::Base.send :include, Customly::Customizable