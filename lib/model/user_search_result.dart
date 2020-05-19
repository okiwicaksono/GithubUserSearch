import 'package:githubusersearch/model/user.dart';

class UserSearchResult {
  int totalCount;
  bool incompleteResults;
  List<User> users;

  UserSearchResult({this.totalCount, this.incompleteResults, this.users});

  UserSearchResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      users = new List<User>();
      json['items'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['incomplete_results'] = this.incompleteResults;
    if (this.users != null) {
      data['items'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
