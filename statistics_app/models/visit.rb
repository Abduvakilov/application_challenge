require_relative 'concerns/field_mapping'
require_relative 'application_record'
require_relative 'pageview'

class Visit < ApplicationRecord
  has_many :pageviews
  accepts_nested_attributes_for :pageviews
  validate :evid_matches_pattern

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

  def evid_pattern
    /\A[A-z0-9]{8}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{12}\z/
  end

  def evid_matches_pattern
    evid.delete_prefix!('evid_')
    self.evid = nil unless evid.match(evid_pattern)
  end

  class << self; attr_accessor :pageviews_source_key end
  @pageviews_source_key = field_mapping.key(:pageviews_attributes).to_s

  include FieldMapping
end
