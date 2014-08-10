module Customly
  class Configuration

    attr_accessor :validations
    attr_reader :field_types
    attr_accessor :flags

    def initialize
      @validations = {}
      @field_types = {}
      @flags = []
    end

    def define_field_type (key, &block)
      ft = Customly::FieldType.new
      yield ft
      @field_types[key] = ft
    end

  end

  class << self 
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

end