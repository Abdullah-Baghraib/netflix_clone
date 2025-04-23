import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:netflix_clone/screens/profile_screen.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/featured_banner_slider.dart';
import '../widgets/movie_category_list.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();

  bool _isLoading = true;
  List<Movie> _featuredMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load all movie categories in parallel
      final results = await Future.wait([
        _apiService.getMovies(AppConstants.popularMoviesEndpoint),
        _apiService.getMovies(AppConstants.trendingMoviesEndpoint),
        _apiService.getMovies(AppConstants.topRatedMoviesEndpoint),
        _apiService.getMovies(AppConstants.upcomingMoviesEndpoint),
      ]);

      // Get favorite status for all movies
      final favorites = await _favoritesService.getFavorites();
      final favoriteIds = favorites.map((movie) => movie.id).toSet();

      // Update movie lists with favorite status
      _popularMovies =
          results[0].map((movie) {
            movie.isFavorite = favoriteIds.contains(movie.id);
            return movie;
          }).toList();

      _trendingMovies =
          results[1].map((movie) {
            movie.isFavorite = favoriteIds.contains(movie.id);
            return movie;
          }).toList();

      _topRatedMovies =
          results[2].map((movie) {
            movie.isFavorite = favoriteIds.contains(movie.id);
            return movie;
          }).toList();

      _upcomingMovies =
          results[3].map((movie) {
            movie.isFavorite = favoriteIds.contains(movie.id);
            return movie;
          }).toList();

      // Set featured movies (top 5 trending movies)
      _featuredMovies = _trendingMovies.take(5).toList();
    } catch (e) {
      print('Error loading data: $e');
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

    // Refresh data to update UI
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/images/netflix_logo.png',
          height: 30,
          fit: BoxFit.fitHeight,
          errorBuilder:
              (context, error, _) => const Text(
                'NETFLIX',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.person_circle),
            onPressed: () {
              // Navigate to profile by setting bottom nav index to 3 in parent
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
              // This would be handled by the parent widget (_MainScreenState)
              // which we don't have direct access to here
            },
          ),
        ],
      ),
      body:
          _isLoading && _featuredMovies.isEmpty
              ? Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadData,
                color: AppConstants.primaryColor,
                child: ListView(
                  children: [
                    // Featured banner slider
                    FeaturedBannerSlider(
                      movies: _featuredMovies,
                      isLoading: _isLoading,
                    ),

                    // Categories
                    MovieCategoryList(
                      title: 'Trending Now',
                      movies: _trendingMovies,
                      isLoading: _isLoading,
                      onFavoriteToggle: _toggleFavorite,
                    ),

                    MovieCategoryList(
                      title: 'Popular',
                      movies: _popularMovies,
                      isLoading: _isLoading,
                      onFavoriteToggle: _toggleFavorite,
                    ),

                    MovieCategoryList(
                      title: 'Top Rated',
                      movies: _topRatedMovies,
                      isLoading: _isLoading,
                      onFavoriteToggle: _toggleFavorite,
                    ),

                    MovieCategoryList(
                      title: 'Coming Soon',
                      movies: _upcomingMovies,
                      isLoading: _isLoading,
                      onFavoriteToggle: _toggleFavorite,
                    ),

                    // Bottom padding
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
