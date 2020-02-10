require 'active_support/concern'

module FieldMapping
  extend ActiveSupport::Concern
  included do
    if respond_to? :field_mapping
      field_mapping.each do |key, value|
        alias_attribute key, value unless key.to_s.eql? value.to_s
      end

      def self.source_fields
        field_mapping.keys
      end
    end
  end
end
