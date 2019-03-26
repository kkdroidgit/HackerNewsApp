import 'dart:async';
import 'package:hn_app/src/article.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

enum StoriesType{
  topStories,
  newStories
}

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  static List<int> _newIds = [
    19490573,
    19477868,
    19487304,
    19484572,
    19487506,
    19485121/*,
    19485558,
    19485559,
    19468090,
    19482159*/
  ];

  static List<int> _topIds = [
    19485558,
    19485559,
    19468090,
    19482159
  ];


  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
      if(storiesType == StoriesType.newStories){
        _getArticlesAndUpdate(_newIds);
      }
      else{
        _getArticlesAndUpdate(_topIds);
      }
    });
  }

  _getArticlesAndUpdate(List<int> ids){
    _updateArticles(ids).then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
