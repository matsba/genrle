import { APIGatewayProxyEvent, Handler } from "aws-lambda";
import { QuizItem, QuizService } from "../services/quizService";
import { HttpHelper } from "../util/httpHelper";

interface AnswerRequest {
  quizId: string;
  optionText: string;
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
