import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multimedia_application/searchpage.dart';
import 'package:multimedia_application/showdetails.dart';
import 'package:multimedia_application/splashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, List<dynamic>> showsByGenre = {};
  List<dynamic> allShows = [];
  int currentShowIndex = 0;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print("Fetching data");
    const url = 'https://api.tvmaze.com/search/shows?q=all';
    final link = Uri.parse(url);
    final response = await http.get(link);
    final body = response.body;
    final jsonData = jsonDecode(body);


    final Map<String, List<dynamic>> genreMap = {};
    for (var item in jsonData) {
      final show = item['show'];
      final genres = show['genres'] as List<dynamic>;

      // Clean up the summary by removing HTML tags
      if (show['summary'] != null) {
        show['summary'] = show['summary'].replaceAll(RegExp(r'<[^>]*>'), '');
      }

      allShows.add(show);
      for (var genre in genres) {
        if (!genreMap.containsKey(genre)) {
          genreMap[genre] = [];
        }
        genreMap[genre]!.add(show);
      }
    }

    setState(() {
      showsByGenre = genreMap;
    });


    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentShowIndex = (currentShowIndex + 1) % allShows.length; // Loop through the shows
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Handle navigation between tabs
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final currentShow = allShows.isNotEmpty ? allShows[currentShowIndex] : null;


    final currentImage = currentShow != null && currentShow['image'] != null
        ? currentShow['image']['original']
        : null;
    final currentName = currentShow?['name'] ?? 'No name available';
    final currentSummary = currentShow?['summary'] ?? 'No summary available';


    final List<Widget> _screens = [

      CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: currentShow != null
                  ? InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowDetailsScreen(show: currentShow)));
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: currentImage != null
                              ? NetworkImage(currentImage)
                              : AssetImage('assets/no_image_available.png')
                          as ImageProvider,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            currentSummary,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : Container(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                String genre = showsByGenre.keys.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        genre,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: showsByGenre[genre]!.length,
                        itemBuilder: (context, index) {
                          final show = showsByGenre[genre]![index];
                          final image = show['image'] != null
                              ? show['image']['original']
                              : null;
                          final name = show['name'];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ShowDetailsScreen(show: show)));
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: image != null
                                            ? NetworkImage(image)
                                            : AssetImage(
                                            'assets/no_image_available.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              childCount: showsByGenre.keys.length,
            ),
          ),
        ],
      ),

      SearchScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Netflix',
          style: TextStyle(color: Colors.red, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontSize: 30),
        ),
        backgroundColor: Colors.black,
        toolbarHeight: 90,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 30),
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
