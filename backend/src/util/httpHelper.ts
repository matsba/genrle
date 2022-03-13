import {
  APIGatewayEventDefaultAuthorizerContext,
  APIGatewayEventRequestContextWithAuthorizer,
} from "aws-lambda/common/api-gateway";
import { APIGatewayRequestAuthorizerEventHeaders } from "aws-lambda/trigger/api-gateway-authorizer";
import { APIGatewayProxyEventHeaders } from "aws-lambda/trigger/api-gateway-proxy";

export class HttpHelper {
  static getUserIdFromHeader(
    headers:
      | APIGatewayProxyEventHeaders
      | APIGatewayRequestAuthorizerEventHeaders,
  ): string | undefined {
    console.log(`Parsed userid header: ${headers.userid}`);
    return headers.userid;
  }

  static getAuthorizedUser(
    requestContext: APIGatewayEventRequestContextWithAuthorizer<APIGatewayEventDefaultAuthorizerContext>,
  ) {
    if (!requestContext.authorizer) {
      throw Error("Unauthorized");
    }
    return requestContext.authorizer.principalId;
  }

  static successResponse(body?: any) {
    if (body) {
      return {
        statusCode: 200,
        body: JSON.stringify(body),
      };
    }
    return {
      statusCode: 204,
    };
  }

  static internalServerErrorResponse(message: string) {
    return {
      statusCode: 500,
      body: JSON.stringify(message),
    };
  }

  static forbiddenResponse() {
    return {
      statusCode: 403,
    };
  }

  static unauthorizerResponse() {
    return {
      statusCode: 401,
    };
  }

  static badRequestResponse() {
    return {
      statusCode: 400,
    };
  }
}
