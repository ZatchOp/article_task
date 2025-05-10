import 'dart:developer';
import 'package:articleapptask/Common/color_class.dart';
import 'package:articleapptask/Common/custom_search_bar.dart';
import 'package:articleapptask/Model/article_model.dart';
import 'package:articleapptask/View/full_article_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteArticlesScreen extends StatefulWidget {
  const FavoriteArticlesScreen({super.key});

  @override
  State<FavoriteArticlesScreen> createState() => _FavoriteArticlesScreenState();
}

class _FavoriteArticlesScreenState extends State<FavoriteArticlesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  late Box<ArticleModel> articleBox;

  List<ArticleModel> favoriteArticleList = [];
  List<ArticleModel> searchListArticleList = [];

  bool isSearchEnabled = false;

  @override
  void initState() {
    super.initState();
    articleBox = Hive.box<ArticleModel>('favorite_article');
    favoriteArticleList = articleBox.values.toList();
  }

  void addArticleToFavorite(ArticleModel article) async {
    if (articleBox.containsKey(article.id)) {
      await articleBox.delete(article.id);
    } else {
      await articleBox.put(article.id, article);
    }

    setState(() {
      favoriteArticleList = articleBox.values.toList();
    });
  }

  bool isFavorite(ArticleModel article) {
    return articleBox.containsKey(article.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmptySearch = isSearchEnabled && searchListArticleList.isEmpty;
    final List<ArticleModel> displayList =
        isSearchEnabled ? searchListArticleList : favoriteArticleList;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.arrowBackIOSColor,
          ),
        ),
        title: const Text(
          "Favorite Articles Detail",
          style: TextStyle(color: AppColors.appBartitleColor),
        ),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            controller: searchController,
            dataList: favoriteArticleList,
            hintText: "Search article by title or body",
            isPaddingEnable: 10,
            onSearchResult: (List<ArticleModel> value) {
              isSearchEnabled = searchController.text.trim().isNotEmpty;
              if (kDebugMode) {
                log("Search results: ${value.length} | Search active: $isSearchEnabled");
              }

              setState(() {
                searchListArticleList = isSearchEnabled ? value : [];
              });
            },
          ),
          if (isEmptySearch)
            const Expanded(
              child: Center(child: Text("No Article Found")),
            )
          else
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final article = displayList[index];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? 15 : 5,
                            bottom: 5,
                          ),
                          child: ListTile(
                            key: ValueKey(article.id),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailArticleScreen(article: article),
                                ),
                              );
                              if (result == true) setState(() {});
                            },
                            title: Text(
                              article.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.articleTitleColor,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              article.body,
                              style: TextStyle(
                                color: AppColors.articleSubTitleColor,
                                fontSize: 14,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                addArticleToFavorite(article);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: isFavorite(article)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        if (index != displayList.length - 1)
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 16,
                            endIndent: 16,
                            color: AppColors.divideColor,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
