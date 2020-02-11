# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative 'models/visit'
require_relative 'models/pageview'

class App
  def self.pageview_keys
    {
      sort: 'timestamp',
      unique: 'pageId',
      position: 'position'
    }
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
        value.sort_by! { |pageview| pageview[pageview_keys[:sort]] }
        value = filter_and_sort_pageviews(value)
      end
      new_hash[key] = value
    end
    new_hash
  end

  def self.filter_and_sort_pageviews(pageviews_array)
    new_array = []
    page_ids_array = []
    current_position = 0
    pageviews_array.each do |pageview|
      id = pageview[pageview_keys[:unique]]
      next if page_ids_array.include? id

      page_ids_array.push(id)
      new_hash = pageview.select do |key, _|
        Pageview.source_fields.include? key
      end
      new_hash[pageview_keys[:position]] = current_position
      current_position += 1
      new_array.push new_hash
    end
    new_array
  end
end

if __FILE__ == $PROGRAM_NAME
  if data = App.get_statistics_json(ENV['API_URI'])
    filtered_data = App.filter_fields(data)
    Visit.create filtered_data
  else
    puts "Cannot get statistics data. URI is #{ENV['API_URI']}"
  end
end
