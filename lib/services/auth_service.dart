import 'dart:async';
import '../models/user.dart' as app_user;

// Mock Auth Service with no Firebase dependency
class AuthService {
  // Mock user stream
  final StreamController<app_user.User?> _userStreamController =
      StreamController<app_user.User?>.broadcast();

  // Mock user data
  final app_user.User _mockUser = app_user.User(
    id: 'mock-user-id',
    email: 'user@example.com',
    displayName: 'Netflix User',
    photoUrl: null,
    isEmailVerified: true,
  );

  // Get current user
  Stream<app_user.User?> get user => _userStreamController.stream;

  // Sign in with email and password (mock)
  Future<app_user.User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always return mock user for UI-only version
    _userStreamController.add(_mockUser);
    return _mockUser;
  }

  // Create a new user with email and password (mock)
  Future<app_user.User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always return mock user for UI-only version
    _userStreamController.add(_mockUser);
    return _mockUser;
  }

  // Sign out (mock)
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _userStreamController.add(null);
  }

  // Send password reset email (mock)
  Future<void> sendPasswordResetEmail(String email) async {
    // Just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }

  // Update user profile (mock)
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    // Just simulate a delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Clean up
  void dispose() {
    _userStreamController.close();
  }
}
