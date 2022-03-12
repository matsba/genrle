import { DocumentClient } from "aws-sdk/clients/dynamodb";
import { dynamoDbClient, getTableName } from "../util/dynamodbClient";
import { v4 } from "uuid";
import { AWSError } from "aws-sdk";
import { QuizItem } from "./quizService";

interface AnswerDatabaseItem {
  PK: string;
  SK: string;
  EntityType: "Answer";
  "GSI1-PK": string;
  Option: string;
  AnswerCorrect: boolean;
}

interface Answer {
  userId: string;
  id: string;
  quizId: string;
  option: string;
  answerCorrect: boolean;
}

export class AnswerService {
  static async getAll(userId: string, quizId: string): Promise<Answer[]> {
    const databaseEntry: DocumentClient.AttributeMap = await dynamoDbClient
      .query({
        TableName: getTableName(),
        ScanIndexForward: true,
        IndexName: "GSI1-PK",
        KeyConditionExpression: "#3a150 = :3a150",
        FilterExpression: "#3a151 = :3a151",
        ExpressionAttributeValues: {
          ":3a150": quizId,
          ":3a151": userId,
        },
        ExpressionAttributeNames: {
          "#3a150": "GSI1-PK",
          "#3a151": "PK",
        },
      })
      .promise();

    if (databaseEntry.Count < 1) {
      return [];
    }

    const answers = databaseEntry.Items.map((x: AnswerDatabaseItem) => ({
      id: x["GSI1-PK"],
      userId: x.PK,
      quizId: x.SK,
      option: x.Option,
      answerCorrect: x.AnswerCorrect,
    }));

    return answers;
  }

  static async insert(
    userId: string,
    quizItem: QuizItem,
    option: string,
  ): Promise<void> {
    const answerCorrect: boolean | undefined = quizItem.question.options.find(
      (x) => x.text == option,
    )?.correct;

    const answer: AnswerDatabaseItem = {
      PK: userId,
      SK: `ANSWER${v4()}`,
      EntityType: "Answer",
      "GSI1-PK": quizItem.id,
      Option: option,
      AnswerCorrect: answerCorrect == undefined ? false : answerCorrect,
    };

    await dynamoDbClient
      .put({
        TableName: getTableName(),
        Item: answer,
      })
      .promise();
  }
}
