import requests, json, sys

conf = open("pyconf.txt", "r")

api_key = conf.read()
base_url = 'http://api.openweathermap.org/data/2.5/weather?'
city_name = sys.argv[1]

# Uses the api and passed arg to build a url then request it
complete_url = base_url + "appid=" + api_key + "&q=" + city_name

response = requests.get(complete_url)

x = response.json()

# Code sources from geeksforgeeks.org what this does is it loads the data into
# vars from the list y using their keys that come from openweathermap.org
# https://www.geeksforgeeks.org/python-find-current-weather-of-any-city-using-openweathermap-api/
if x["cod"] != "404":
    y = x["main"]
    current_temperature = y["temp"]
    current_pressure = y["pressure"]
    current_humidity = y["humidity"]
    z = x["weather"]
    weather_description = z[0]["description"]

    # writes data to a text file to be read by lua
    f = open("report.txt", "w")
    f.write(" Temperature (in kelvin unit) = " +
                    str(current_temperature) +
          "\n atmospheric pressure (in hPa unit) = " +
                    str(current_pressure) +
          "\n humidity (in percentage) = " +
                    str(current_humidity) +
          "\n description = " +
                    str(weather_description))
    f.close()