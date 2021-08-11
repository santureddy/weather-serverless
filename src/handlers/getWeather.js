import { v4 as uuid } from 'uuid';
import AWS from 'aws-sdk';
import commonMiddleware from '../lib/commonMiddleware';
import createError from 'http-errors';

const got = require('got');
const dynamodb = new AWS.DynamoDB.DocumentClient();

async function getWeather(event, context) {

  const now = new Date();

  console.log(event.queryStringParameters.zip);

  const zip = event.queryStringParameters.zip;

  const response = await got(`https://api.openweathermap.org/data/2.5/weather?zip=${zip}&appid=b9d8502288bbe640ecf8a5c8c0d96616&units=imperial`, {
    https: {
      rejectUnauthorized: true
    }
  });
  console.log(response);
  const parsedRes = JSON.parse(response.body);
  const weatherReport = {
    id: uuid(),
    temp: `${(parsedRes.main.temp)}`,
    zipcode: `${zip}`,
    //requestedAt: now.toISOString().slice(0, 10),
    requestedAt: now.toISOString(),
  };

  try {
    await dynamodb.put({
      TableName: process.env.WEATHER_TABLE_NAME,
      Item: weatherReport,
    }).promise();
  }
  catch (error) {
    console.log(error);
    throw new createError.InternalServerError(error);

  }

  return {
    statusCode: 200,
    body: JSON.stringify(weatherReport),
  };
}

export const handler = commonMiddleware(getWeather);

