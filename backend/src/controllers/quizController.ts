import { APIGatewayProxyEvent, Handler } from "aws-lambda";
import {
  GetAllQuizItemsStructure,
  Question,
  QuestionImage,
  QuizItem,
  QuizService,
} from "../services/quizService";
import { HttpHelper } from "../util/httpHelper";

interface AnswerRequest {
  quizId: string;
  optionText: string;
}

interface CreateRequest {
  questionImage: QuestionImage;
  question: Question;
}

export const getLatest: Handler = async (event: APIGatewayProxyEvent) => {
  const quizItem: QuizItem | null = await QuizService.getLatest();

  if (quizItem == null) {
    return {
      statusCode: 404,
    };
  }

  return {
    statusCode: 200,
    body: JSON.stringify(quizItem),
  };
};

export const getAll: Handler = async (event: APIGatewayProxyEvent) => {
  const quizItems: GetAllQuizItemsStructure = await QuizService.getAll();

  return HttpHelper.successResponse(quizItems);
};

export const answer: Handler = async (event: APIGatewayProxyEvent) => {
  const userId = HttpHelper.getAuthorizedUser(event.requestContext);

  if (event.body != null) {
    const request: AnswerRequest = JSON.parse(event.body);
    try {
      await QuizService.answer(userId, request.quizId, request.optionText);
      return {
        statusCode: 204,
      };
    } catch (error: any) {
      return {
        statusCode: 500,
      };
    }
  }
};

export const create: Handler = async (event: APIGatewayProxyEvent) => {
  console.log(event.body);
  if (event.body != null) {
    try {
      console.log("Parsing json..");
      const quizItem: QuizItem = JSON.parse(event.body);
      console.log(`Parsed! ${quizItem}`);

      console.log("Creating item...");
      await QuizService.create(quizItem);
      console.log("Success!");

      return HttpHelper.successResponse();
    } catch (error) {
      console.error(error);
      HttpHelper.internalServerErrorResponse((error as Error).message);
    }
  } else {
    return HttpHelper.badRequestResponse();
  }
};
