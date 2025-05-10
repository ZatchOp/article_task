import 'dart:async';

import 'package:articleapptask/Controller/Network/article_api_call.dart';
import 'package:articleapptask/Model/article_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleService articleService;
  ArticleBloc(this.articleService) : super(ArticleInitial()) {
    on<FetchArticles>(onFetchArticles);
  }

  FutureOr<void> onFetchArticles(
      FetchArticles event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      final articles = await articleService.fetchArticles();
      emit(ArticleLoaded(articles));
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }
}
