module Customly
  module ViewHelpers

    def custom_field_types
      Customly.configuration.field_types
    end

    def custom_field_tag(form, cfv)
      custom_field = cfv.custom_field
      label_text = custom_field.label
      
      ft = FieldType.find_by_key(custom_field.field_type)
      field = case ft.input_type
      when :text_field
        form.text_field :value, value: cfv.value, :required => custom_field.is_required?
      end

      field + (form.hidden_field :custom_field_id, value: custom_field.id)
    end
  end
end