require 'customly/version'

# Config
require 'customly/field_type'
require 'customly/configuration'

# Concerns
require 'customly/concerns/parentable'
require 'customly/concerns/skopeable'
require 'customly/concerns/customizable'

# Models
require 'customly/models/custom_field'
require 'customly/models/custom_field_skope'
require 'customly/models/custom_field_value'

# Helpers
require 'customly/view_helpers'

module Customly

  SUPPORTED_INPUT_TYPES = [ 
    :text_field,
    :text_area,
    :select,
    :radio,
    :check_box
  ]

  class Engine < ::Rails::Engine
    initializer :customly do |config|
      ActiveRecord::Base.class_eval do
        include Parentable, Skopeable, Customizable
      end
      
      ActionView::Base.send :include, ViewHelpers
      ActionController::Base.send :include, ViewHelpers

    end
  end
end


