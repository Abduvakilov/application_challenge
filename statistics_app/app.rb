require 'net/http'
require 'uri'
require 'json'
require_relative 'models/visit'
require_relative 'models/pageview'

class App
  def self.get_statistics_json(uri)
    api_uri = URI.parse(uri)
    response = Net::HTTP.get_response(api_uri)

    return JSON.parse(response.body) if response.is_a? Net::HTTPSuccess
  end

  def self.filter_fields(visits_array)
    new_array = []
    visits_array.each do |visit_hash|
      new_hash = filter_visit_fields(visit_hash)
      new_array.push new_hash
    end
    new_array
  end

  def self.filter_visit_fields(visit_hash)
    new_hash = {}
    visit_hash.each do |key, value|
      next unless Visit.source_fields.include? key

      value = filter_pageview_fields(value) if key == Visit.pageviews_source_key
      new_hash[key] = value
    end
    new_hash
  end

  def self.filter_pageview_fields(pageviews_array)
    new_array = []
    pageviews_array.each do |pageview|
      new_hash = pageview.select { |k, _| Pageview.source_fields.include? k }
      new_array.push new_hash
    end
    new_array
  end

  def self.write_statistics_into_db(uri)
    json = get_statistics_json(uri)
    filtered_data = filter_fields(json)
    Visit.create filtered_data
  end
end

res = App.write_statistics_into_db(ENV['API_URI'])
