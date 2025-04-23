import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        _profile = profile;
      });
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isLoading && _profile != null)
            IconButton(
              icon: const Icon(CupertinoIcons.pencil),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(profile: _profile!),
                  ),
                );

                if (result == true) {
                  _loadProfile(); // Reload profile data
                }
              },
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              )
              : ListView(
                children: [
                  // Profile avatar and name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              _profile?.avatarUrl != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _profile!.avatarUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Center(
                                    child: Icon(
                                      CupertinoIcons.person_fill,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _profile?.name ?? 'User Profile',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _profile?.email ?? 'user@example.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  const Divider(color: Colors.grey),

                  // Settings list
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.person_crop_circle,
                    title: 'Manage Profiles',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.download_circle,
                    title: 'Downloads',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.bell,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.play_rectangle,
                    title: 'My List',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.globe,
                    title: 'Language',
                    subtitle: _profile?.language ?? 'English',
                    onTap: () {},
                  ),

                  // Divider
                  const Divider(color: Colors.grey),

                  // Account settings
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.creditcard,
                    title: 'Subscription & Billing',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.settings,
                    title: 'App Settings',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.question_circle,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.info_circle,
                    title: 'About',
                    onTap: () {},
                  ),

                  // Divider
                  const Divider(color: Colors.grey),

                  // Sign out button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              )
              : null,
      trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
