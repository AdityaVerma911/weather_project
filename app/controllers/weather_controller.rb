class WeatherController < ApplicationController
  def index
    # Render the search form
  end

  def fetch_weather
    @city = params[:city]
    @country_code = params[:country_code]

    weather_service = Weatherbit::Client.new(city: @city, country_code: @country_code)
    weather_data = weather_service.fetch_weather_data

    respond_to do |format|
      if weather_data
        @average_temperature = calculate_average_temperature(weather_data)
        @weekly_forecast = format_weekly_forecast(weather_data)
        format.html { render 'index' } # Render the template
      else
        flash[:alert] = "Could not fetch weather data. Please try again."
        format.html { redirect_to root_path }
      end
    end
  end


  private

  def calculate_average_temperature(data)
    daily_temperatures = data['data'].map { |day| day['temp'] }.first(10)
    (daily_temperatures.sum / daily_temperatures.size.to_f).round(1)
  end

  def format_weekly_forecast(data)
    data['data'].first(7).map do |day|
      {
          day: Date.parse(day['datetime']).strftime('%A'),
          temperature: day['temp'].round(1)
      }
    end
  end
end
