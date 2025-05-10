import 'package:articleapptask/Common/color_class.dart';
import 'package:articleapptask/Model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DetailArticleScreen extends StatefulWidget {
  final ArticleModel article;

  const DetailArticleScreen({super.key, required this.article});

  @override
  State<DetailArticleScreen> createState() => _DetailArticleScreenState();
}

class _DetailArticleScreenState extends State<DetailArticleScreen> {
  late Box<ArticleModel> articleBox;
  List<ArticleModel> favoriteArticleList = [];

  @override
  void initState() {
    articleBox = Hive.box<ArticleModel>('favorite_article');
    isFavorite(widget.article);
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.arrowBackIOSColor,
            )),
        title: const Text(
          "Article Detail",
          style: TextStyle(color: AppColors.appBartitleColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addArticleToFavorite(widget.article);
            },
            icon: Icon(
              Icons.favorite,
              color: isFavorite(widget.article) ? Colors.red : Colors.grey,
            ),
          ),
        ],
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.article.body,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
