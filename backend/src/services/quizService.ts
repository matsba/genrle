import { DocumentClient } from "aws-sdk/clients/dynamodb";
import { v4 } from "uuid";
import { dynamoDbClient, getTableName } from "../util/dynamodbClient";
import { AnswerService } from "./answerService";
import { UserService } from "./userService";

export interface QuestionImage {
  src: string;
  title: string;
  subTitle: string;
}

export interface Question {
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
  image: QuestionImage;
  question: Question;
}

export interface GetAllQuizItemsStructure {
  count: number;
  quizItems: QuizItem[];
}

interface QuizItemDatabaseItem {
  PK: string;
  SK: string;
  image: QuestionImage;
  question: Question;
  EntityType: "QuizItem";
  createdTime: string;
}

const mapFromDatabase = (databaseEntry: DocumentClient.AttributeMap) => {
  const items: QuizItem[] = databaseEntry.Items.map(
    (x: QuizItemDatabaseItem) =>
      ({
        id: x.PK,
        created: x.createdTime,
        image: x.image,
        question: x.question,
      } as QuizItem),
  );
  return items;
};

export class QuizService {
  static async getLatest(): Promise<QuizItem | null> {
    const databaseEntry: DocumentClient.AttributeMap = await dynamoDbClient
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

    if (databaseEntry.Count < 1) {
      return null;
    }

    const quizItem = mapFromDatabase(databaseEntry)[0];

    // const quizItem: QuizItem = {
    //   id: databaseEntry.Items[0].PK,
    //   created: databaseEntry.Items[0].createdTime,
    //   image: databaseEntry.Items[0].image,
    //   question: databaseEntry.Items[0].question,
    // };

    return quizItem;
  }

  static async get(quizId: string): Promise<QuizItem | null> {
    const databaseEntry: DocumentClient.AttributeMap = await dynamoDbClient
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

    if (databaseEntry.Count < 1) {
      return null;
    }

    const quizItem = mapFromDatabase(databaseEntry)[0];

    return quizItem;
  }

  static async getAll(): Promise<GetAllQuizItemsStructure> {
    const databaseEntry: DocumentClient.AttributeMap = await dynamoDbClient
      .scan({
        TableName: getTableName(),
        FilterExpression: "begins_with(#e14e0, :e14e0)",
        ExpressionAttributeNames: { "#e14e0": "PK" },
        ExpressionAttributeValues: { ":e14e0": "QUIZ" },
      })
      .promise();

    if (databaseEntry.Count < 1) {
      return { count: 0, quizItems: [] };
    }

    const quizItems = mapFromDatabase(databaseEntry);
    return { count: databaseEntry.Count, quizItems: quizItems };
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

  static async create(quizItem: QuizItem) {
    const timeNow = new Date().toISOString();

    const insertItem: QuizItemDatabaseItem = {
      PK: `QUIZITEM#${v4()}`,
      SK: timeNow.split("T")[0],
      EntityType: "QuizItem",
      createdTime: timeNow,
      image: quizItem.image,
      question: quizItem.question,
    };

    await dynamoDbClient
      .put({
        TableName: getTableName(),
        Item: insertItem,
      })
      .promise();
  }
}
