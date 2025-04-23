import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Movie> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await _apiService.searchMovies(query);

      // Get favorite status for results
      final favorites = await _favoritesService.getFavorites();
      final favoriteIds = favorites.map((movie) => movie.id).toSet();

      // Update search results with favorite status
      _searchResults =
          results.map((movie) {
            movie.isFavorite = favoriteIds.contains(movie.id);
            return movie;
          }).toList();
    } catch (e) {
      print('Error searching: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(Movie movie) async {
    if (movie.isFavorite) {
      await _favoritesService.removeFromFavorites(movie.id);
    } else {
      await _favoritesService.addToFavorites(movie);
    }

    // Refresh search results to update UI
    _performSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for a movie or TV show',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _hasSearched = false;
                });
              },
            ),
          ),
          onSubmitted: _performSearch,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _searchResults = [];
                _hasSearched = false;
              });
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search input field (in AppBar)

          // Results
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.primaryColor,
                      ),
                    )
                    : _hasSearched && _searchResults.isEmpty
                    ? Center(
                      child: Text(
                        'No results found',
                        style: AppConstants.bodyStyle,
                      ),
                    )
                    : !_hasSearched
                    ? Center(
                      child: Text(
                        'Search for movies and TV shows',
                        style: AppConstants.bodyStyle,
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = _searchResults[index];
                        return MovieCard(
                          movie: movie,
                          height: double.infinity,
                          width: double.infinity,
                          onFavoriteToggle: _toggleFavorite,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
