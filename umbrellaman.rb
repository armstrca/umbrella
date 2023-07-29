require "http"
require "json"
pp "Where are you?"
user_location = gets.chomp
gmaps_key = ENV.fetch("GMAPS_KEY")
google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

gmaps_data = HTTP.get(google_url)
parsed_gmaps_data = JSON.parse(gmaps_data)
results = parsed_gmaps_data.fetch("results")
results2 = results.fetch(0)
geometry = results2.fetch("geometry")
location = geometry.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")

weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_url = "https://api.pirateweather.net/forecast/#{weather_key}/#{lat},#{lng}"

weather_data = HTTP.get(weather_url)
parsed_weather_data = JSON.parse(weather_data)
currently = parsed_weather_data.fetch("currently")
current_temperature = currently.fetch("temperature")
hourly = parsed_weather_data.fetch("hourly")
next_hour_summary = hourly.fetch("summary")
hourly_data_array = hourly.fetch("data")
hourly_data_hash = hourly_data_array.at(0)
first_hourly_precip = hourly_data_hash.fetch("precipProbability") 
#twelvehour_array = hourly_data_array.at(0..11)#
#twelvehour_precipprob_array = twelvehour_array.fetch("precipProbability")

twelvehour_data_array = [hourly_data_array[0], hourly_data_array[1], hourly_data_array[2], hourly_data_array[3], hourly_data_array[4], hourly_data_array[5], hourly_data_array[6], hourly_data_array[7], hourly_data_array[8], hourly_data_array[9], hourly_data_array[10], hourly_data_array[11]]



pp "The current temperature in #{user_location} is #{current_temperature} degrees Fahrenheit."
pp "The forecast for the next hour in #{user_location} is #{next_hour_summary}."
pp "The precipitation probability for the next hour in #{user_location} is #{first_hourly_precip}%."


12.times do |n|
  hourly_data_hash = hourly_data_array.at(n)
  n = hourly_data_hash.fetch("precipProbability") 
  if n >= 0.1
    pp "You might want an umbrella today!"
  else
    pp "You probably won't need an umbrella today."
end
end