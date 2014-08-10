module Customly
  module ViewHelpers
    def custom_field_types
      Customly.configuration.field_types
    end

    def custom_field_tag(form, cfv, html_options = {})
      cf = cfv.custom_field
      
      new_value = html_options.delete(:value)

      ft = FieldType.find_by_key(cf.field_type)

      if ft.present?
        ft_html_options = ft.html_options || {}
        html_options[:class] = "#{ft_html_options.delete[:class]} #{html_options[:class]}" if html_options[:class] && ft_html_options[:class]
        html_options.merge!(ft_html_options)

        field = nil
        value = (new_value || cfv.value || cf.default_value)

        if ft.custom_render?
          opts = {form: form, cfv: cfv, value: value}
          field = self.instance_exec(opts, &ft.render)
        else
          field = case ft.input_type
          when :select
            options = options_for_select(cf.options || [], value)
            form.select :value, options , {prompt: "", include_blank: ft.include_blank_option}, {required: cf.is_required?}.merge(html_options)

          when :text_area
            form.text_area :value, {value: value, required: cf.is_required?}.merge(html_options)        

          else #text_field
            form.text_field :value, {value: value, required: cf.is_required?}.merge(html_options)        
          end
        end

        result = field
        unless ft.static
          result += (form.hidden_field :custom_field_id, value: cf.id) 
          result += (form.hidden_field :id, value: cfv.id) if cfv.id.present?
        end
        result
      else 
        logger.info "Error: Failed to find FieldType for key: #{cf.field_type}"
      end
    end
  end
end