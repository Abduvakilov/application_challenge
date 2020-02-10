require 'net/http'
require 'uri'
require 'json'
require_relative 'models/visit'
require_relative 'models/pageview'

class App
  def self.pageview_sort_field
    'timestamp'
  end

  def self.pageview_unique_field
    'pageId'
  end

  def self.pageview_position_field
    'position'
  end

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

      if key == Visit.pageviews_source_key
        value.sort_by! { |pageview| pageview[pageview_sort_field] }
        value = filter_pageview_fields(value)
      end
      new_hash[key] = value
    end
    new_hash
  end

  def self.filter_pageview_fields(pageviews_array)
    new_array = []
    page_ids_array = []
    current_position = 0
    pageviews_array.each do |pageview|
      id = pageview[pageview_unique_field]
      next if page_ids_array.include? id

      page_ids_array.push(id)
      new_hash = pageview.select { |key, _| Pageview.source_fields.include? key }
      new_hash[pageview_position_field] = current_position
      current_position += 1
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
puts res
