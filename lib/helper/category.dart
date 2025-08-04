import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news/helper/blog_tile.dart';
import '../model/acticle.dart';
import 'package:http/http.dart' as http;

class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Article> categoryNews = [];
  String selectedSortingCriteria = 'publishedAt'; // Default sorting criteria

  Future<void> getCategoryNews(String requiredCategory) async {
    var response = await http.get(
      Uri.parse(
        "https://newsapi.org/v2/top-headlines?category=$requiredCategory&country=in&from=2023-12-24&sortBy=$selectedSortingCriteria&apiKey=8b044788ea34482f831e672ce29fd7be",
      ),
    );
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      for (var element in jsonData['articles']) {
        if (element['urlToImage'] != null && element['title'] != null) {
          final articleModel = Article(
            name: element['source']['name'] ?? 'name',
            title: element['title'] ?? 'title',
            url: element['url'],
            urlToImage: element['urlToImage'] ?? 'Image',
            publishedAt: element['publishedAt'] ?? 'Time',
          );
          categoryNews.add(articleModel);
        }
      }

      // Sort articles based on selected sorting criteria
      sortCategoryNews();
    }
  }

  Future<void> sortCategoryNews() async {
    // Sort articles based on selected sorting criteria using News API
    var response = await http.get(
      Uri.parse(
        "https://newsapi.org/v2/top-headlines?category=${widget.category}&country=in&apiKey=8b044788ea34482f831e672ce29fd7be&sortBy=popularity",
      ),
    );
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      categoryNews.clear(); // Clear existing news
      for (var element in jsonData['articles']) {
        if (element['urlToImage'] != null && element['title'] != null) {
          final articleModel = Article(
            name: element['source']['name'] ?? 'name',
            title: element['title'] ?? 'title',
            url: element['url'],
            urlToImage: element['urlToImage'] ?? 'Image',
            publishedAt: element['publishedAt'] ?? 'Time',
          );
          categoryNews.add(articleModel);
        }
      }
    }

    setState(() {
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(176, 166, 211, 202),
        title: const Text('Sort By'),
        actions: [
          // Add a dropdown button for sorting criteria
          DropdownButton<String>(
            value: selectedSortingCriteria,
            onChanged: (value) {
              setState(() {
                selectedSortingCriteria = value!;
                sortCategoryNews();
              });
            },
            items: const [
              DropdownMenuItem<String>(
                value: 'publishedAt',
                child: Text('Sort by Date'),
              ),
              DropdownMenuItem<String>(
                value: 'popularity',
                child: Text('Sort by Popularity'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categoryNews.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: BlogTile(
              blogName: categoryNews[index].name,
              blogTitle: categoryNews[index].title,
              blogUrl: categoryNews[index].url,
              blogUrlToImage: categoryNews[index].urlToImage,
              blogPublishedAt: categoryNews[index].publishedAt,
            ),
          );
        },
      ),
    );
  }
}
