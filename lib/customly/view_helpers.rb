module Customly
  module ViewHelpers
    def custom_field_types
      Customly.configuration.field_types
    end

    def custom_field_tag(form, cfv, html_options = {})
      cf = cfv.custom_field
      
      ft = FieldType.find_by_key(cf.field_type)

      ft_html_options = ft.html_options || {}
      html_options[:class] = "#{ft_html_options.delete[:class]} #{html_options[:class]}" if html_options[:class] && ft_html_options[:class]
      html_options.merge!(ft_html_options)

      field = nil

      if ft.custom_render?
        field = self.instance_exec(form, cfv, &ft.render)
      else
        field = case ft.input_type
        when :select
          options = options_for_select(cf.options || [], (cfv.value || cf.default_value))
          form.select :value, options , {prompt: ""}, {required: cf.is_required?}.merge(html_options)

        when :text_area
          form.text_area :value, {value: cfv.value, required: cf.is_required?}.merge(html_options)        

        else
          form.text_field :value, {value: cfv.value, required: cf.is_required?}.merge(html_options)        
        end
      end

      result = field
      unless ft.static
        result += (form.hidden_field :custom_field_id, value: cf.id) 
        result += (form.hidden_field :id, value: cfv.id) if cfv.id.present?
      end
      result
    end
  end
end