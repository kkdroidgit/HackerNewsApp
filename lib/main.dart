import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/hn_bloc.dart';

Future main() async {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(bloc: hnBloc));
}


class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp({
    Key key,
    this.bloc
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final HackerNewsBloc bloc;

  MyHomePage({Key key, this.bloc}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
          children: snapshot.data.map(_buildItem).toList(),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            title: Text('Top Stories'),
            icon: Icon(Icons.new_releases),
          ),
          BottomNavigationBarItem(
            title: Text('New Stories'),
            icon: Icon(Icons.new_releases),
          )
        ],
        onTap: (index){
          if(index == 0){
            widget.bloc.storiesType.add(StoriesType.topStories);
          }
          else{
            widget.bloc.storiesType.add(StoriesType.newStories);
          }
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(''),
    );
  }


  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(16),
      child: ExpansionTile(
        title: Text(article.title, style: TextStyle(fontSize: 20),),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(article.type),
            ],
          )
        ],
      ),
    );
  }







}




