import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFFE50914);
  static const Color secondaryColor = Color(0xFF221F1F);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color buttonColor = Color(0xFFE50914);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFF8C8C8C);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    color: textColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingStyle = TextStyle(
    color: textColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStyle = TextStyle(color: textColor, fontSize: 14);

  static const TextStyle subtitleStyle = TextStyle(
    color: greyColor,
    fontSize: 12,
  );

  // TMDB API URLs
  static const String baseApiUrl = 'https://api.themoviedb.org/3';
  static const String apiKey ='API_key'; // Your TMDB API key
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';

  // TMDB API Endpoints
  static const String popularMoviesEndpoint = '/movie/popular';
  static const String trendingMoviesEndpoint = '/trending/movie/week';
  static const String upcomingMoviesEndpoint = '/movie/upcoming';
  static const String topRatedMoviesEndpoint = '/movie/top_rated';
  static const String popularTvShowsEndpoint = '/tv/popular';
  static const String trendingTvShowsEndpoint = '/trending/tv/week';

  // Tab Names
  static const List<String> mainNavItems = [
    'Home',
    'TV Shows',
    'Movies',
    'My List',
  ];

  // Category Names
  static const List<String> movieCategories = [
    'Popular',
    'Trending',
    'New Releases',
    'Top Rated',
    'Action',
    'Comedy',
    'Horror',
    'Romance',
  ];
}
