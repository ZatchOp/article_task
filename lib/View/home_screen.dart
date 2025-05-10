import 'package:articleapptask/Common/color_class.dart';
import 'package:articleapptask/Common/custom_search_bar.dart';
import 'package:articleapptask/Controller/bloc/article_bloc.dart';
import 'package:articleapptask/Model/article_model.dart';
import 'package:articleapptask/View/favorite_ariticles_screen.dart';
import 'package:articleapptask/View/full_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late Box<ArticleModel> articleBox;
  List<ArticleModel> favoriteArticleList = [];
  List<ArticleModel> searchListArticleList = [];
  bool isSearchEnabled = false;

  @override
  void initState() {
    super.initState();
    context.read<ArticleBloc>().add(FetchArticles());
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.appBartitleColor,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: Badge(
              isLabelVisible: favoriteArticleList.isNotEmpty,
              label: Text("${favoriteArticleList.length}"),
              child: IconButton(
                icon: const Icon(Icons.article,
                    color: AppColors.appBartitleColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteArticlesScreen(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      setState(() {
                        articleBox = Hive.box<ArticleModel>('favorite_article');
                        favoriteArticleList = articleBox.values.toList();
                      });
                    }
                  });
                },
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.appBarColor,
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleLoaded) {
            // Determine what list to display
            final displayList =
                isSearchEnabled ? searchListArticleList : state.articles;

            return Column(
              children: [
                CustomSearchBar(
                  controller: searchController,
                  dataList: state.articles,
                  hintText: "Search article by title or body",
                  isPaddingEnable: 10,
                  onSearchResult: (List<ArticleModel> value) {
                    isSearchEnabled = searchController.text.trim().isNotEmpty;
                    searchListArticleList = value;
                    setState(() {});
                  },
                ),
                if (isSearchEnabled && searchListArticleList.isEmpty)
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<ArticleBloc>().add(FetchArticles());
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        },
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailArticleScreen(
                                              article: article),
                                        ),
                                      ).then((value) {
                                        if (value == true) setState(() {});
                                      });
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
                  ),
              ],
            );
          } else if (state is ArticleError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Pull down to load articles"));
        },
      ),
    );
  }
}
