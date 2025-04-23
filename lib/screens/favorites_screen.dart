import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:netflix_clone/screens/home_screen.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/favorites_service.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  List<Movie> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    try {
      final favorites = await _favoritesService.getFavorites();
      setState(() {
        _favorites = favorites;
      });
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(Movie movie) async {
    await _favoritesService.removeFromFavorites(movie.id);
    _loadFavorites(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        title: const Text(
          'My List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              )
              : _favorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your list is empty',
                      style: TextStyle(color: Colors.grey[400], fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add movies to your list to see them here',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.textColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text('Explore Movies'),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadFavorites,
                color: AppConstants.primaryColor,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final movie = _favorites[index];
                    return MovieCard(
                      movie: movie,
                      height: double.infinity,
                      width: double.infinity,
                      onFavoriteToggle: _toggleFavorite,
                    );
                  },
                ),
              ),
    );
  }
}
