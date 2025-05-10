import 'dart:developer';
import 'package:articleapptask/Model/article_model.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final List<ArticleModel> dataList;
  final ValueChanged<List<ArticleModel>> onSearchResult;
  final double? isPaddingEnable;
  final String hintText;
  final TextEditingController controller;

  const CustomSearchBar({
    required this.hintText,
    required this.dataList,
    required this.onSearchResult,
    required this.controller,
    this.isPaddingEnable,
    super.key,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  int _lastExecution = 0;
  final int _throttleDuration = 300;

  void onSearchChanged(String query) {
    final int now = DateTime.now().millisecondsSinceEpoch;

    if (now - _lastExecution >= _throttleDuration) {
      _lastExecution = now;

      final searchResults = widget.dataList
          .where((data) =>
              data.title.toLowerCase().contains(query.toLowerCase()) ||
              data.body.toLowerCase().contains(query.toLowerCase()))
          .toList();

      log("Throttled Search: ${searchResults.map((e) => e.title).toList()}");

      widget.onSearchResult(searchResults);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.isPaddingEnable ?? 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black.withOpacity(.6)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.6),
            spreadRadius: 0.5,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search_rounded),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: onSearchChanged,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
