if (!process.env.AWS_REGION) {
  process.env.AWS_REGION = "eu-north-1";
}

if (!process.env.DYNAMODB_NAMESPACE) {
  process.env.DYNAMODB_NAMESPACE = "dev";
}

import { DynamoDB } from "aws-sdk";

// In offline mode, use DynamoDB local server
let options = {};

// connect to local DB if running offline
if (process.env.IS_OFFLINE) {
  options = {
    region: "localhost",
    endpoint: "http://localhost:8000",
  };
}

export const dynamoDbClient = new DynamoDB.DocumentClient(options);

export const getTableName = () => {
  //console.log(`Using table: genrle-backend-${process.env.DYNAMODB_NAMESPACE}`);
  return `genrle-backend-${process.env.DYNAMODB_NAMESPACE}`;
};
