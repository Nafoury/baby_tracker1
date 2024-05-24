// ActivityDetailPage.dart
import 'package:baba_tracker/models/articlesModel.dart';
import 'package:baba_tracker/view/more/ActivityItem.dart';
import 'package:flutter/material.dart';

class ActivityDetailPage extends StatelessWidget {
  final String imageUrl;
  final String description;
  final ActivityItem activity;

  ActivityDetailPage({
    required this.imageUrl,
    required this.description,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    // Find the related article based on the activity's relatedArticle property
    Article relatedArticle = articles.firstWhere((article) =>
        article.title == activity.relatedArticle ||
        articles.indexOf(article) == activity.relatedArticle);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageUrl,
                  width: 600,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Render activity details using the activity object
                // (e.g., activity.subtitle, activity.imageUrl, etc.)
                // Render related article sections here
                Column(
                  children: [
                    Text(
                      relatedArticle.title, // Display the article title
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...relatedArticle.sections.map((section) => Text(
                          section,
                          style: TextStyle(color: Colors.grey.shade600),
                        )), // Display article sections
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
