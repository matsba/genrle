import { APIGatewayRequestAuthorizerEvent } from "aws-lambda/trigger/api-gateway-authorizer";
import { HttpHelper } from "../util/httpHelper";
import { UserService } from "./userService";

export const handler = async (event: APIGatewayRequestAuthorizerEvent) => {
  console.log("Checking authorization...");

  if (!event.headers) {
    return HttpHelper.badRequestResponse();
  }
  const userId = HttpHelper.getUserIdFromHeader(event.headers);

  if (userId == null) {
    console.error("No userId in headers!");
    throw Error("BadRequest");
  }

  const userFound = await UserService.getById(userId);

  if (!userFound) {
    console.error("No user not found from database!");
    throw Error("Unauthorized");
  }

  return generatePolicy(userId, event.methodArn);
};

const generatePolicy = (principalId: string, methodArn: string) => {
  console.log("Generating policy...");
  return {
    principalId: principalId,
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: "Allow",
          Resource: methodArn,
        },
      ],
    },
  };
};
