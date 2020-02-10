require_relative 'concerns/field_mapping'
require_relative 'application_record'
require_relative 'pageview'

class Visit < ApplicationRecord
  has_many :pageviews
  accepts_nested_attributes_for :pageviews 

  def self.field_mapping
    {
      'referrerName'  => :evid,
      'idSite'        => :vendor_site_id,
      'idVisit'       => :vendor_visit_id,
      'visitIp'       => :visit_ip,
      'visitorId'     => :vendor_visitor_id,
      'actionDetails' => :pageviews_attributes
    }
  end

  class << self; attr_accessor :pageviews_source_key end
  @pageviews_source_key = field_mapping.key(:pageviews_attributes)

  include FieldMapping
end
