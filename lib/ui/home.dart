import 'package:flutter/material.dart';
import 'package:githubusersearch/model/user.dart';
import 'package:githubusersearch/provider/user_provider.dart';
import 'package:githubusersearch/repository/user_repository.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserRepository _userRepository;
  TextEditingController _searchQueryController;
  ScrollController _scrollController;
  bool _isPerformingRequest;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _searchQueryController = TextEditingController();
    _scrollController = ScrollController();
    _isPerformingRequest = false;
  }

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          void _scrollListener() {
            if (_scrollController.offset >=
                    _scrollController.position.maxScrollExtent &&
                !_scrollController.position.outOfRange) {
              print('reach the bottom');
              _getData(context, isLoadMore: true);
            }
          }

          Future.delayed(Duration(seconds: 2), () {
            if (_scrollController.hasClients) {
              _scrollController.addListener(_scrollListener);
            }
          });

          final emptyWidget = userProvider.query.isEmpty
              ? _buildEmptyView(context)
              : _buildZeroResultView(context, userProvider.query);

          return userProvider.users.isEmpty
              ? emptyWidget
              : _buildListView(context, userProvider.users);
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            size: 100,
            color: Colors.black26,
          ),
          Text(
            'Search Github user using search menu.',
            style: TextStyle(color: Colors.black26),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroResultView(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.cancel,
            size: 100,
            color: Colors.black26,
          ),
          Text(
            'Zero results for "$query"',
            style: TextStyle(color: Colors.black26),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<User> users) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black26,
      ),
      controller: _scrollController,
      itemCount: users.length,
      itemBuilder: (context, index) {
        User user = users[index];
        return Column(
          children: <Widget>[
            ListTile(
              leading: AspectRatio(
                aspectRatio: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image(
                    image: NetworkImage(user.avatarUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text(user.login),
            ),
            SizedBox(),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => value.trim().isEmpty
          ? _showErrorDialog("Empty value", "Please fill the text to search!")
          : _getData(context, query: value.trim(), isLoadMore: false),
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Enter username or keyword",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black26),
        contentPadding: EdgeInsets.all(16.0),
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              return;
            }
            _clearSearchQuery();
          },
          icon: Icon(Icons.clear),
        ),
      ),
      onChanged: (_) => _userRepository.resetSearchData(context),
    );
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
    });

    _userRepository.resetSearchData(context);
  }

  void _getData(BuildContext context,
      {String query, bool isLoadMore = false}) async {
    setState(() {
      _isPerformingRequest = !_isPerformingRequest;
    });

    _showProgressDialog(context);

    final response = await _userRepository.getUsersWithQuery(context, query,
        isLoadMore: isLoadMore);

    if (!response.success)
      _showErrorDialog(response.message.title, response.message.description);

    Navigator.of(context).pop();

    setState(() {
      _isPerformingRequest = !_isPerformingRequest;
    });
  }

  void _showErrorDialog(String title, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(errorMessage),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Center(
                child: Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait...",
                  )
                ]),
              )
            ],
          );
        });
  }
}
