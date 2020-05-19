class HTTPStatusCode {
  static const ok = 200;
  static const created = 201;
  static const noContent = 204;
  static const permanentRedirection = 301;
  static const temporaryRedirection1 = 302;
  static const temporaryRedirection2 = 307;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const unprocessableEntity = 422;
  static const internalServerError = 500;
}

enum ResponseType { rest }

class ResponseMessage {
  final String title;
  final String description;

  ResponseMessage({this.title, this.description});

  factory ResponseMessage.fromJson(dynamic json) {
    return ResponseMessage(
        title: json['title'], description: json['description']);
  }
}

class RequestResponse {
  final bool success;
  final ResponseType type;
  final int code;
  final ResponseMessage message;
  final dynamic data;

  RequestResponse(
      {this.success,
      this.type,
      this.code = HTTPStatusCode.badRequest,
      this.message,
      this.data});

  factory RequestResponse.fromJson(dynamic json) {
    final typeString = json['type'];
    final type =
        ResponseType.values.firstWhere((e) => e.toString() == typeString);
    return RequestResponse(
        success: json['success'],
        type: type,
        code: json['code'],
        message: json['message'],
        data: json['data']);
  }
}

class Response {
  RequestResponse success(ResponseType type, int code, dynamic data) {
    return requestResponse(true, type, code, data);
  }

  RequestResponse error(ResponseType type,
      {int code = HTTPStatusCode.badRequest, String errorMessage}) {
    return requestResponse(false, type, code, [], errorMessage: errorMessage);
  }

  RequestResponse requestResponse(
      bool success, ResponseType type, int code, dynamic data,
      {String errorMessage}) {
    final response = RequestResponse(
      success: success,
      type: type,
      code: code,
      message: errorMessage ?? message(type, code: code),
      data: data,
    );

    return response;
  }

  ResponseMessage message(ResponseType type,
      {int code = HTTPStatusCode.badRequest}) {
    return httpResponse(code: code);
  }

  ResponseMessage httpResponse({int code = HTTPStatusCode.badRequest}) {
    final message = {
      HTTPStatusCode.ok: ResponseMessage(
          title: "OK", description: "The request has succeeded."),
      HTTPStatusCode.created: ResponseMessage(
          title: "Created",
          description:
              "The request has succeeded and a new resource has been created as a result."),
      HTTPStatusCode.noContent: ResponseMessage(
          title: "No Content",
          description: "There is no content to send for this request."),
      HTTPStatusCode.permanentRedirection: ResponseMessage(
          title: "Permanent redirection",
          description:
              "The URI you used to make the request has been superseded by the one specified in the Location header field."),
      HTTPStatusCode.temporaryRedirection1: ResponseMessage(
          title: "Temporary redirection",
          description:
              "The request should be repeated verbatim to the URI specified in the Location header field but clients should continue to use the original URI for future requests."),
      HTTPStatusCode.temporaryRedirection2: ResponseMessage(
          title: "Temporary redirection",
          description:
              "The request should be repeated verbatim to the URI specified in the Location header field but clients should continue to use the original URI for future requests."),
      HTTPStatusCode.badRequest: ResponseMessage(
          title: "Bad Request",
          description:
              "The server could not understand the request due to invalid syntax."),
      HTTPStatusCode.unauthorized: ResponseMessage(
          title: "Unauthorized",
          description:
              "The request does not have valid authentication credentials for the operation."),
      HTTPStatusCode.forbidden: ResponseMessage(
          title: "Forbidden",
          description: "API rate limit exceeded. Please try again later."),
      HTTPStatusCode.notFound: ResponseMessage(
          title: "Not Found",
          description: "The server can not find the requested resource."),
      HTTPStatusCode.unprocessableEntity: ResponseMessage(
          title: "Unprocessable Entity",
          description:
              "The server understands the content type of the request entity (hence a 415 (Unsupported Media Type) status code is inappropriate)."),
      HTTPStatusCode.internalServerError: ResponseMessage(
          title: "Internal Server Error",
          description: "Oops! Something went wrong. Please try again."),
    };

    return message[code] ??
        ResponseMessage(title: "Unknown", description: "Unknown HTTP error!");
  }
}
