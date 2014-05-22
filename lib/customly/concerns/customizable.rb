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
        fields = Customly::CustomField.joins(:custom_field_skopes).where(wc)
        fields = fields.where(private: false) unless show_private
        fields.order('position')
      end
      
      def find_or_build_custom_field_values(skopes, show_private: false)
        available_custom_fields(skopes, show_private: show_private).map do |cf|
          custom_field_values.detect { |v| v.custom_field == cf } ||
          custom_field_values.build(:customized => self, :custom_field => cf, :value => cf.default_value)
        end
      end

      def find_or_create_custom_field_values!(skopes, show_private: false)
        available_custom_fields(skopes, show_private: show_private).map do |cf|
          custom_field_values.detect { |v| v.custom_field == cf } ||
          custom_field_values.create(:customized => self, :custom_field => cf, :value => cf.default_value)
        end
      end

      
    end
  end
end

ActiveRecord::Base.send :include, Customly::Customizable