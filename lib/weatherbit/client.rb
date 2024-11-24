module Weatherbit
  class Client
    require 'faraday'

    BASE_URL = 'https://api.weatherbit.io/v2.0/forecast/daily'

    def initialize(city:, country_code:)
      @city = city
      @country_code = country_code
      @api_key = ENV['WEATHERBIT_API_KEY']
    end

    def fetch_weather_data
      response = Faraday.get(BASE_URL, {
          city: @city,
          country: @country_code,
          key: @api_key
      })

      if response.success?
        JSON.parse(response.body)
      else
        nil
      end
    end
  end
end


