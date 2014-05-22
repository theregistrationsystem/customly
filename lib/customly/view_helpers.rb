module Customly
  module ViewHelpers

    def custom_field_types
      Customly.configuration.field_types
    end

    def custom_field_tag(form, cfv, html_options = {})
      custom_field = cfv.custom_field
      label_text = custom_field.label
      
      ft = FieldType.find_by_key(custom_field.field_type)

      ft_html_options = ft.html_options || {}
      html_options[:class] = "#{ft_html_options.delete[:class]} #{html_options[:class]}" if html_options[:class] && ft_html_options[:class]
      html_options.merge!(ft_html_options)

      field = case ft.input_type
      when :text_field
        form.text_field :value, {value: cfv.value, required: custom_field.is_required?}.merge(html_options)

      when :select
        options = options_for_select(custom_field.options || [], (cfv.value || custom_field.default_value))
        form.select :value, options , {prompt: ""}, {required: custom_field.is_required?}.merge(html_options)

      end

      field + (form.hidden_field :custom_field_id, value: custom_field.id) + (form.hidden_field :id, value: cfv.id)
    end
  end
end