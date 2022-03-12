import { APIGatewayProxyEvent, Handler } from "aws-lambda";
import { User, UserService } from "../services/userService";
import { HttpHelper } from "../util/httpHelper";

interface UpdateScoreRequest {
  points: number;
}

export const get: Handler = async (event: APIGatewayProxyEvent) => {
  const userId = HttpHelper.getAuthorizedUser(event.requestContext);

  const user: User | null = await UserService.getById(userId);

  return {
    statusCode: 200,
    body: JSON.stringify(user),
  };
};

export const register: Handler = async (event: APIGatewayProxyEvent) => {
  const userIdFromHeader = HttpHelper.getUserIdFromHeader(event.headers);

  if (userIdFromHeader) {
    return {
      statusCode: 403,
    };
  }

  const user: User = await UserService.create();

  return {
    statusCode: 200,
    body: JSON.stringify(user),
  };
};
