import 'package:flutter/material.dart';


class ShowDetailsScreen extends StatelessWidget {
  final dynamic show;

  ShowDetailsScreen({required this.show});

  @override
  Widget build(BuildContext context) {
    final imageUrl = show['image'] != null ? show['image']['original'] : null;
    final name = show['name'] ?? 'No name available';


    String cleanSummary() {
      String summary = show['summary'] ?? 'No summary available';
      if (show['summary'] != null) {
        summary = summary.replaceAll(RegExp(r'<[^>]*>'), '');
      }
      return summary;
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUrl != null
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Icon(Icons.image, color: Colors.grey, size: 200),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanSummary(), // Use cleaned summary here
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {

                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: MoreInfoPage(show: show),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Show More',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MoreInfoPage extends StatelessWidget {
  final dynamic show;

  MoreInfoPage({required this.show});

  @override
  Widget build(BuildContext context) {
    final rating = show['rating'] != null ? show['rating']['average'] : 'No rating available';
    final genre = show['genres'] != null && show['genres'].isNotEmpty
        ? show['genres']
        : ['No genre available']; // List of genres

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display Genre Title and Genres in a Column
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Genre:',
                style: TextStyle(
                  color: Colors.grey[700], // Darker color for the label
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: genre.map<Widget>((g) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  g,
                  style: TextStyle(
                    color: Colors.white, // Lighter color for genre items
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),

          // Display Rating Title and Rating Value
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rating:',
                style: TextStyle(
                  color: Colors.grey[700], // Darker color for the label
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              rating is double ? rating.toStringAsFixed(1) : rating.toString(),
              style: TextStyle(
                color: Colors.white, // Lighter color for rating
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
