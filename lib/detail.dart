import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String overview;

  MovieDetailPage({
    required this.title,
    required this.imageUrl,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(overview),
            ),
          ],
        ),
      ),
    );
  }
}
