module Customly
  class CustomField < ActiveRecord::Base

    #== ASSOCIATIONS
    belongs_to :parent, polymorphic: true
    has_many :custom_field_values, inverse_of: :custom_field
    has_many :custom_field_skopes

    #== VALIDATIONS
    validates :name, presence: true
    validates :field_type, presence: true

    validate { (Customly.configuration.validations[:custom_field] || []).each { |blk| blk.call self } }

    #== ATTRIBUTES
    serialize :options

    FLAG_SEPERATOR = "~"

    # ["one", "two"] => "~one~two~" 
    def flags=(f_arr)
      write_attribute(:flags, (FLAG_SEPERATOR + f_arr.reject(&:blank?).join(FLAG_SEPERATOR) + FLAG_SEPERATOR))
    end

    # "~one~two~" => ["one", "two"]
    def flags
      (attributes["flags"].blank? ? read_attribute(:flags) : attributes["flags"]).to_s.split(FLAG_SEPERATOR).reject(&:blank?)
    end

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