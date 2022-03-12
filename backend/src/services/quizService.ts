import { DocumentClient } from "aws-sdk/clients/dynamodb";
import { dynamoDbClient, getTableName } from "../util/dynamodbClient";
import { v4 } from "uuid";
import { AWSError } from "aws-sdk";
import { AnswerService } from "./answerService";
import { UserService } from "./userService";

interface QuestionImage {
  src: string;
  title: string;
  subTitle: string;
}

interface Question {
  text: string;
  options: Option[];
}

interface Option {
  text: string;
  correct: boolean | false;
}

export interface QuizItem {
  id: string;
  created: string;
  questionImage: QuestionImage;
  question: Question;
}

export class QuizService {
  static async getLatest(): Promise<QuizItem | null> {
    const databaseEnry: DocumentClient.AttributeMap = await dynamoDbClient
      .scan({
        TableName: getTableName(),
        ConsistentRead: false,
        FilterExpression: "begins_with(#e14e0, :e14e0)",
        Limit: 1,
        ExpressionAttributeValues: {
          ":e14e0": "QUIZITEM#",
        },
        ExpressionAttributeNames: {
          "#e14e0": "PK",
        },
      })
      .promise();

    if (databaseEnry.Count < 1) {
      return null;
    }

    const quizItem: QuizItem = {
      id: databaseEnry.Items[0].PK,
      created: databaseEnry.Items[0].SK,
      questionImage: databaseEnry.Items[0].questionImage,
      question: databaseEnry.Items[0].question,
    };

    return quizItem;
  }

  static async get(quizId: string): Promise<QuizItem | null> {
    const databaseEnry: DocumentClient.AttributeMap = await dynamoDbClient
      .query({
        TableName: getTableName(),
        ScanIndexForward: true,
        ConsistentRead: false,
        KeyConditionExpression: "#e14e0 = :e14e0",
        ExpressionAttributeValues: {
          ":e14e0": quizId,
        },
        ExpressionAttributeNames: {
          "#e14e0": "PK",
        },
      })
      .promise();

    if (databaseEnry.Count < 1) {
      return null;
    }

    const quizItem: QuizItem = {
      id: databaseEnry.Items[0].PK,
      created: databaseEnry.Items[0].SK,
      questionImage: databaseEnry.Items[0].questionImage,
      question: databaseEnry.Items[0].question,
    };

    return quizItem;
  }

  static async answer(
    userId: string,
    quizId: string,
    option: string,
  ): Promise<void> {
    const pointsForCorrectAnswer = 2;
    const quizItem = await this.get(quizId);

    if (!quizItem) {
      throw Error("Error when answering: Quiz item not found!");
    }

    const answersNotFound =
      (await AnswerService.getAll(userId, quizId)).length < 1;

    if (answersNotFound) {
      console.log("First time answering! Adding answer to database...");
      await AnswerService.insert(userId, quizItem, option);
      console.log(`Increasing users points by ${pointsForCorrectAnswer} ...`);
      await UserService.incrementPointsBy(userId, pointsForCorrectAnswer);
    } else {
      console.log(
        "Answered already, but adding answer to database regardless...",
      );
      await AnswerService.insert(userId, quizItem, option);
    }
  }
}
