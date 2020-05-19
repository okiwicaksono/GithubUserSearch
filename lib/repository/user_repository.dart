import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:githubusersearch/helper/request_response.dart';
import 'package:githubusersearch/model/user_search_result.dart';
import 'package:githubusersearch/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class UserRepository {
  static final _log = Logger("UserRepository");
  static final _userSearchUrl = "https://api.github.com/search";

  Future<RequestResponse> getUsersWithQuery(BuildContext context, String query,
      {int page = 1, bool isLoadMore = false}) async {
    final userPerPage = 100; // always load 100 user per page
    final client = http.Client();
    final _response = Response();

    try {
      if (isLoadMore) {
        page = Provider.of<UserProvider>(context).page;
        query = Provider.of<UserProvider>(context).query;
      }

      String params = '/users?q=$query&page=$page&per_page=$userPerPage';

      var uri = Uri.parse(_userSearchUrl + params);

      final httpResponse = await client.get(uri, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });

      Map data = json.decode(httpResponse.body);
      if (httpResponse.statusCode == HTTPStatusCode.ok) {
        UserSearchResult userSearchResult = UserSearchResult.fromJson(data);

        userSearchResult.users
            .forEach((user) => Provider.of<UserProvider>(context).add(user));
        Provider.of<UserProvider>(context).page++;
        Provider.of<UserProvider>(context).query = query;

        return _response.success(
            ResponseType.rest, httpResponse.statusCode, userSearchResult);
      }

      String errorMessage = data["message"];

      return _response.error(ResponseType.rest,
          code: httpResponse.statusCode, errorMessage: errorMessage);
    } catch (error) {
      _log.severe(error.toString());
      return _response.error(ResponseType.rest);
    } finally {
      client.close();
    }
  }

  void resetSearchData(BuildContext context) {
    Provider.of<UserProvider>(context).reset();
  }
}
