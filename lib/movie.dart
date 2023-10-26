import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled/detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String selectedCategory = 'now_playing';
  final httphelper httpHelper = httphelper();
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  Future<List<dynamic>> _fetchMovies(String category, String searchTerm) async {
    if (category == 'search' && searchTerm.isEmpty) {
      // Jika pencarian kosong, kembali ke kategori yang dipilih sebelumnya
      category = selectedCategory;
    }
    
    String categoryUrl = category == 'search' ? 'search/movie' : 'movie/$category';
    String searchQuery = category == 'search' ? '&query=$searchTerm' : '';
    final response = await httpHelper.getMovie(categoryUrl, searchQuery);
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> movies = data['results'];
    return movies;
  }

  void _onGridTileTapped(BuildContext context, String title, String imageUrl, String overview) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(
          title: title,
          imageUrl: imageUrl,
          overview: overview,
        ),
      ),
    );
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      // Pembaruan daftar film berdasarkan teks pencarian
      // Anda bisa mengimplementasikan logika pencarian di sini
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Categories'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select a Movie Category:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Column(
            children: <Widget>[
              RadioListTile(
                title: Text('Now Playing'),
                value: 'now_playing',
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.toString();
                    _searchController.clear(); // Hapus teks pencarian saat beralih kategori
                    _onSearchTextChanged('');
                  });
                },
              ),
              RadioListTile(
                title: Text('Popular'),
                value: 'popular',
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.toString();
                    _searchController.clear();
                    _onSearchTextChanged('');
                  });
                },
              ),
              RadioListTile(
                title: Text('Top rated'),
                value: 'top_rated',
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.toString();
                    _searchController.clear();
                    _onSearchTextChanged('');
                  });
                },
              ),
              RadioListTile(
                title: Text('Upcoming'),
                value: 'upcoming',
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.toString();
                    _searchController.clear();
                    _onSearchTextChanged('');
                  });
                },
              ),
            ],
          ),
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchTextChanged,
            decoration: InputDecoration(
              hintText: 'Search for a movie...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _onSearchTextChanged('');
                        });
                      },
                    )
                  : null,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchMovies(
                  _searchController.text.isNotEmpty ? 'search' : selectedCategory, _searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List? movies = snapshot.data as List?;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: movies!.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return GridTile(
                          child: GestureDetector(
                            onTap: () {
                              _onGridTileTapped(
                                context,
                                '${movie['title']}',
                                'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                                '${movie['overview']}',
                              );
                            },
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          footer: GridTileBar(
                            title: _searchController.text.isNotEmpty
                                ? Text(
                                    '${movie['title']}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text('${movie['title']}'),
                            backgroundColor: Colors.black.withOpacity(0.7),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class httphelper {
  final String _urlKey = "?api_key=de29189b6884c538ec4426c5e54319a4";
  final String _urlbase = "https://api.themoviedb.org";

  Future<String> getMovie(String category, String searchQuery) async {
    var url = Uri.parse(_urlbase + '/3/$category' + _urlKey + searchQuery);
    http.Response result = await http.get(url);
    if (result.statusCode == 200) {
      String responseBody = result.body;
      return responseBody;
    }
    return result.statusCode.toString();
  }
}
