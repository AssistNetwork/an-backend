require "json"
#require "rest_client" : itt majd kell valami

class Maps
  attr_accessor :api, :key

  def initialize
    @api = RestClient::Resource.new "https://maps.googleapis.com/maps/api"
    @key = ENV['KEY'] || abort("KEY not defined")
  end

  def resources
    {
        nearby:      ["place/nearbysearch/json",  "results"],
        details:     ["place/details/json",       "result"],
        directions:  ["directions/json",          "routes"],
        geocode:     ["geocode/json",             "results"],
    }
  end

  def request(resource, params)
    api[resource].get(params: params.merge(key: key)) do |response|
      JSON.parse(response).tap do |result|
        status = result.delete("status")
        raise status if status != "OK"
      end
    end
  end

  def method_missing(m, *args, &block)
    resource = resources[m]
    super unless resource
    request(resource.first, *args)[resource.last]
  end
end

class MinimalMaps
  attr_accessor :api

  def initialize
    @api = Maps.new
  end

  def geocode(params)
    api.geocode(params).map do |result|
      {
          address: result['formatted_address'],
          location: result['geometry']['location'].values.join(","),
      }
    end
  end

  def directions(params)
    api.directions(params).map do |route|
      {
          bounds: {
              ne: route['bounds']['northeast'].values.join(","),
              sw: route['bounds']['southwest'].values.join(","),
          },
          legs: route['legs'].map do |leg|
            {
                distance: leg['distance'],
                duration: leg['duration'],
                end_address: leg['end_address'],
                end_location: leg['end_location'].values.join(","),
                start_address: leg['start_address'],
                start_location: leg['start_location'].values.join(","),
                steps: leg['steps'].map do |step|
                  {
                      distance: step['distance'],
                      duration: step['duration'],
                      end_location: step['end_location'].values.join(","),
                      start_location: step['start_location'].values.join(","),
                      html_instructions: step['html_instructions'],
                      maneuver: step["straight"],
                  }
                end,
            }
          end,
      }
    end
  end

  def nearby(params)
    api.nearby(params).map do |result|
      {
          location: result['geometry']['location'].values.join(","),
          name: result['name'],
          placeid: result['place_id'],
      }
    end
  end

  def details(params)
    api.details(params).tap do |result|
      break {
          address: result['formatted_address'],
          location: result['geometry']['location'].values.join(","),
          name: result['name'],
          reviews: result['reviews'].map do |review|
            {
                aspects: review['aspects'],
                rating: review['rating'],
                text: review['text'],
                time: review['time'],
            }
          end,
      }
    end
  end
end

require 'net/http'
require 'rexml/document'

module MapMonkey
  class Position
    attr_accessor :city, :street, :zip

    def initialize(params)
      @city   = URI.encode(params.fetch(:city, ""))
      @street = URI.encode(params.fetch(:street, ""))
      @zip    = URI.encode(params.fetch(:zip, ""))
    end

    def url
      "http://maps.googleapis.com/maps/api/geocode/xml?address=#{street}#{zip}#{city}&sensor=false"
    end

    def response
      Net::HTTP.get_response(URI.parse(url)).body
    end

    def get_lat
      doc = REXML::Document.new(response)

      doc.elements.each('GeocodeResponse/result/geometry/location/lat') do |ele|
        @lat = ele.text
      end

      @lat
    end

    def get_lng
      doc = REXML::Document.new(response)

      doc.elements.each('GeocodeResponse/result/geometry/location/lng') do |ele|
        @lng = ele.text
      end

      @lng
    end

    def get_lat_lng
      [get_lat, get_lng]
    end
  end
end

module MapMonkey
  class Annotation
    attr_accessor :icon, :size, :title, :body_text
  end
end

require 'map_monkey/position'
module MapMonkey

  class << self
    def new(params = {})
      MapMonkey.new(params)
    end
  end
end

