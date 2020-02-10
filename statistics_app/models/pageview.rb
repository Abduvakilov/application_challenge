require_relative 'concerns/field_mapping'
require_relative 'application_record'
require_relative 'visit'

class Pageview < ApplicationRecord
  belongs_to :visit
  def self.field_mapping
    {
      'url'       => :url,
      'pageTitle' => :title,
      'timeSpent' => :time_spent,
      'timestamp' => :timestamp
    }
  end
  include FieldMapping

end
