# build
npm install

# deployment steps 
sls deploy -v

# api endpoints

## Get the weather of specific zipcode area
GET - https://41ftpuimq0.execute-api.eu-west-1.amazonaws.com/dev/getWeather
 

## Fetch the report data from dynamo db
 GET - https://41ftpuimq0.execute-api.eu-west-1.amazonaws.com/dev/getWeatherReport


example:

https://41ftpuimq0.execute-api.eu-west-1.amazonaws.com/dev/getWeather?zip=94040


https://41ftpuimq0.execute-api.eu-west-1.amazonaws.com/dev/getWeatherReport?zip=77001