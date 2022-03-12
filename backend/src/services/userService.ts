import { DocumentClient } from "aws-sdk/clients/dynamodb";
import { dynamoDbClient, getTableName } from "../util/dynamodbClient";
import { v4 } from "uuid";

const _generateUserName = () =>
  `User#${Math.floor(Math.random() * 100000 + 1)}`;

interface UserDatabaseItem {
  PK: string;
  SK: string;
  username: string;
  points: number;
}

export interface User {
  id: string;
  username: string;
  points: number;
}

export class UserService {
  static async getById(userId: string): Promise<User | null> {
    const databaseEnry: DocumentClient.AttributeMap = await dynamoDbClient
      .get({
        TableName: getTableName(),
        Key: { PK: userId, SK: userId },
      })
      .promise();

    if (databaseEnry.Item == null) {
      return null;
    }

    const user: User = {
      id: databaseEnry.Item.PK,
      username: databaseEnry.Item.username,
      points: databaseEnry.Item.points,
    };

    return user;
  }

  static async create(): Promise<User> {
    const userId = v4();

    const generatedUser: UserDatabaseItem = {
      PK: `USER#${userId}`,
      SK: `USER#${userId}`,
      username: _generateUserName(),
      points: 0,
    };

    await dynamoDbClient
      .put({
        TableName: getTableName(),
        Item: generatedUser,
      })
      .promise();

    console.log("Registered user: ", generatedUser);

    const user: User = {
      id: generatedUser.PK,
      username: generatedUser.username,
      points: generatedUser.points,
    };

    return user;
  }

  static async incrementPointsBy(
    userId: string,
    points: number,
  ): Promise<void> {
    await dynamoDbClient
      .update({
        TableName: getTableName(),
        Key: { PK: userId, SK: userId },
        UpdateExpression: "ADD #a :p",
        ExpressionAttributeValues: { ":p": Number(points) },
        ExpressionAttributeNames: { "#a": "points" },
      })
      .promise();
  }
}
