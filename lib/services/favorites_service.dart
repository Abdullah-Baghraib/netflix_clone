import '../models/movie.dart';

// A simple in-memory implementation of favorites service
class FavoritesService {
  // In-memory storage of favorite movies
  static final List<Movie> _favorites = [];

  // Add a movie to favorites
  Future<bool> addToFavorites(Movie movie) async {
    try {
      // Check if movie already exists in favorites
      if (_favorites.any((element) => element.id == movie.id)) {
        return false;
      }

      // Add the movie to favorites
      final updatedMovie = movie..isFavorite = true;
      _favorites.add(updatedMovie);
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove a movie from favorites
  Future<bool> removeFromFavorites(int movieId) async {
    try {
      // Remove the movie from favorites
      _favorites.removeWhere((movie) => movie.id == movieId);
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  // Get all favorite movies
  Future<List<Movie>> getFavorites() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_favorites);
  }

  // Check if a movie is in favorites
  Future<bool> isFavorite(int movieId) async {
    return _favorites.any((movie) => movie.id == movieId);
  }

  // Clear all favorites
  Future<bool> clearFavorites() async {
    try {
      _favorites.clear();
      return true;
    } catch (e) {
      print('Error clearing favorites: $e');
      return false;
    }
  }
}
