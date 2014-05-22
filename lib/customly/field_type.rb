module Customly
  class FieldType
    attr_accessor :key,
                  :label,
                  :input_type,
                  :validation,
                  :default_value,
                  :possible_values,
                  :html_options

    def initialize
      @input_type = :text_field
      @default_value = ""
      @html_options = {}
    end

    def self.find_by_key(k)
      Customly.configuration.field_types[k.to_sym]
    end
  end
end