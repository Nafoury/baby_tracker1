// ActivityDetailPage.dart
import 'package:baba_tracker/models/articlesModel.dart';
import 'package:baba_tracker/view/more/ActivityItem.dart';
import 'package:flutter/material.dart';

class ActivityDetailPage extends StatelessWidget {
  final String description;
  final ActivityItem activity;

  ActivityDetailPage({
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
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
