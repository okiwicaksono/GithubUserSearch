import 'package:flutter/material.dart';
import 'package:githubusersearch/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github User Search',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
        child: MyHomePage(title: 'Github User Search'),
      ),
    );
  }
}
