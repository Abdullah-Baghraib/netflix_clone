import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/movie.dart';

// API Service that connects to The Movie Database (TMDB) API
class ApiService {
  // Get movies by endpoint
  Future<List<Movie>> getMovies(String endpoint, {int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseApiUrl}$endpoint?api_key=${AppConstants.apiKey}&page=$page',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  // Search movies
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseApiUrl}/search/multi?api_key=${AppConstants.apiKey}&query=$query',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results
            .where(
              (item) =>
                  item['media_type'] == 'movie' || item['media_type'] == 'tv',
            )
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching movies: $e');
      return [];
    }
  }

  // Get movie details
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseApiUrl}/movie/$movieId?api_key=${AppConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      // Return a placeholder movie if the API call fails
      return Movie(
        id: movieId,
        title: 'Movie Not Found',
        overview: 'Unable to load movie details',
        voteAverage: 0.0,
        releaseDate: '',
        genreIds: [],
      );
    }
  }

  // Get recommended movies
  Future<List<Movie>> getRecommendedMovies(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseApiUrl}/movie/$movieId/recommendations?api_key=${AppConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception(
          'Failed to load recommended movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching recommended movies: $e');
      return [];
    }
  }

  // Get video key
  Future<String?> getVideoKey(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseApiUrl}/movie/$movieId/videos?api_key=${AppConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        if (results.isNotEmpty) {
          // Find trailer or return first video
          final trailer = results.firstWhere(
            (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
            orElse: () => results.first,
          );
          return trailer['key'];
        }
        return null;
      } else {
        throw Exception('Failed to load video: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching video key: $e');
      return null;
    }
  }
}
