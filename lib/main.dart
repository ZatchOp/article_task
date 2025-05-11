import 'package:articleapptask/Controller/Network/article_api_call.dart';
import 'package:articleapptask/Controller/bloc/article_bloc.dart';
import 'package:articleapptask/Model/article_model.dart';
import 'package:articleapptask/View/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive
    ..initFlutter()
    ..registerAdapter(ArticleModelAdapter());
  await Hive.openBox<ArticleModel>('favorite_article');
  runApp(const ArticleApp());
}

class ArticleApp extends StatelessWidget {
  const ArticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Article App',
      home: BlocProvider(
        create: (_) => ArticleBloc(ArticleService()),
        child: const HomeScreen(title: "Articles"),
      ),
    );
  }
}
