import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

class ProfileService {
  static const String _profileKey = 'user_profile';

  // Get the current user profile
  Future<Profile> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);

      if (profileJson != null) {
        return Profile.fromJson(jsonDecode(profileJson));
      }
    } catch (e) {
      print('Error getting profile: $e');
    }

    // Return default profile if none exists
    return Profile(
      name: 'User Profile',
      email: 'user@example.com',
      avatarUrl: null,
      language: 'English',
    );
  }

  // Save the user profile
  Future<bool> saveProfile(Profile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    } catch (e) {
      print('Error saving profile: $e');
      return false;
    }
  }

  // Update a specific profile field
  Future<bool> updateProfileField(String field, dynamic value) async {
    try {
      final profile = await getProfile();
      final updatedProfile = profile.copyWith(
        name: field == 'name' ? value : profile.name,
        email: field == 'email' ? value : profile.email,
        avatarUrl: field == 'avatarUrl' ? value : profile.avatarUrl,
        language: field == 'language' ? value : profile.language,
      );

      return await saveProfile(updatedProfile);
    } catch (e) {
      print('Error updating profile field: $e');
      return false;
    }
  }
}
