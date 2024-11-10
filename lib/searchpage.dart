import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multimedia_application/showdetails.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchShows(String searchTerm) async {
    if (searchTerm.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data;
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching results')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.search, color: Colors.black),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchShows(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var show = _searchResults[index]['show'];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowDetailsScreen(show: show)));
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: show['image'] != null
                  ? Image.network(
                show['image']['medium'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.image, color: Colors.grey),
              title: Text(
                show['name'],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                show['genres']?.join(', ') ?? 'No genres',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }
}
