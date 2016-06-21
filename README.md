Adds advanced custom field support to your application. 

# Setup

## migrations

`rake customly_engine:install:migrations`

## config

You first define your custom field types in a config file:

- Create a customly.config file under `config/initializers`

Example:

````ruby
Customly.configure do |config|
  # You add custom validations to the CustomField and CustomFieldValue models.
  config.validations =  { custom_field: [
                            -> (obj) { obj.errors.add(:base, "You can't edit a custom field that is in use") if obj.custom_field_values.count > 1 }
                          ]
                        }

  # Optional way to categorize custom fields to be filtered by.
  config.flags = [:guest, :user, :admin]

  # Example single line input. 
  # The first argument `:sli` is the key you wish to give this field_type which will be stored on the custom field record.
  # The key is used to look up the field type given a custom field. If you change the key you will need to change it in the `field_type` column on all custom field records.
  config.define_field_type :sli do |ft|
    ft.label = "Single Line Input"
    ft.input_type = :text_field
  end

  # Example mutli line text area
  config.define_field_type :mli do |ft|
    ft.label = "Multi Line Input"
    ft.input_type = :text_area
  end

  # Example select field.
  # You can pass in custom html options to any field type.
  config.define_field_type :ddl do |ft|
    ft.label = "Single Option List"
    ft.input_type = :select
    ft.html_options = {class: "autocomplete", data: {sort_field: "$order"}}
    ft.include_blank_option = true
  end
  
  # Example custom input type and overriding the render.
  config.define_field_type :section_header do |ft|
    ft.label = "Section Header"
    ft.input_type = :custom
    ft.static = true
    ft.render = -> (opts) { content_tag(:h3, opts[:cfv].custom_field.name) }
  end
end
````

- define_field_type options:
  - key (Symbol)
  
    unique key to lookup field type from a custom field record.  
  - label
  
    For your own use (ex: to show in dropdown of custom field types)
  - input_type

    One of:
    - :text_field
    - :select
    - :text_area
    - :document_upload
    - :image_upload
    - anything else will be treated as a text field unless you override using `render` option.

  - default_value
  
    Fallback default value when rendered.
    
  - html_options
  
    A hash of options merged into input tag's html options

  - render

    A proc to override the default rendering. The proc takes a single hash argument with the following key-values:
    - form: form object
    - cfv: CustomFieldValue instance
    - value: current value
    - html_options: html_options hash

  - static
  
    Boolean to determine if the field will be saved. Defaults to false.
    
  - config
  
    A hash of configuration. Currently only supports :max_file_size for uploads.
    
  - include_blank_option
  
    Boolean to include a blank option for `:select`'s. Defaults to false.

## Include model associations and helpers

There are 3 concerns:

Call `is_customizable` in the model that you want attach custom field values to.

````ruby
class Person < ActiveRecord::Base
  is_customizable

  # see: lib/customly/concerns/customizable.rb
end
````

Call `is_customly_parent` in the model that will own the custom fields.

````ruby
class Organization < ActiveRecord::Base
  is_customly_parent
  
  # see: lib/customly/concerns/parentable.rb
end
````

Call `is_customly_skope` in models that will act as a scope for a subset of the parent's custom fields.

````ruby
class Team < ActiveRecord::Base
  is_customly_skope
  
  # see: lib/customly/concerns/skopeable.rb
end
````

Example scenario:

Assuming Organization ABC has 3 custom fields:
1) What is your t-shirt size?
2) What is your age?
3) ID upload.

Persons belonging to Team A might only need to fill out custom fields 1 & 2. 
That is to say the custom fields 1 & 2 are scoped to Team A. 

You can go further by using flags. You can say a Person of type `:guest` belonging to Team A 
should only see custom fields scoped to Team A that have the flag `:guest`.

# CRUDing custom fields is up to the host application

Example form to create custom fields:

````ruby
= form_for @custom_field
  = f.text_field :name, placeholder: "Name (public)"
  = f.text_field :label, placeholder: "Label (reference)"
  = f.select :field_type, custom_field_types.map { |k,v| [v.label, k] }, {}
  = f.text_area :instructions, placeholder: "Instructions"
  = f.text_field :default_value, placeholder: "Default Value"
  = f.text_field :options, placeholder: "Select field type options (comma seperated)"
  = f.check_box f, :is_required
  = f.check_box f, :private
  = f.submit
````

in the controller:

````ruby
def create
  # ...
  @organization.custom_fields.create(params)
  # ...
end
````

Associating a `CustomField` persisted instance with `is_customly_skope` records is also upto the host application. 
This can be done in many ways depending on your UX preference.

To render the custom fields you can call the `find_or_build_custom_field_values` on an `is_customizable` instance. Passing in the scope.
For example:

  ````ruby
    form @person do |f|
      = f.text_field :name # not custom field
      # custom fields
      - @person.find_or_build_custom_field_values(@person.team).each do |cfv|
        = custom_field_tag(f, cfv)
  ````

## License

Copyright (c) 2016 The Registration System.

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
