module Customly
  class CustomField < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :parent, polymorphic: true
    has_many :custom_field_values
    has_many :custom_field_skopes

    #== VALIDATIONS
    validates :name, presence: true
    validates :label, presence: true, uniqueness: true
    validates :field_type, presence: true

    validate { (Customly.configuration.validations[:custom_field] || []).each { |blk| blk.call self } }

    #== ATTRIBUTES
    serialize :options

    #== SCOPES
    scope :not_in_skope, -> (skope) do
     skoped_fields = skope.custom_field_skopes.map(&:custom_field_id).compact
     where("id NOT IN (?)", skoped_fields.to_a) unless skoped_fields.blank?
    end

    #== INSTANCE METHODS

    def build_clone
      parent.custom_fields.new(clone_field_attributes)
    end

    # == CLASS METHODS

    private

      def clone_field_attributes
        self.attributes.reject {|k,v| [:id, :created_at, :updated_at].include?(k.to_sym) } 
      end
  end
end