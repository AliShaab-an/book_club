import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/core/utils/app_colors.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_notifier.dart';
import '../../domain/entities/app_user.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_menu_tile.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'preferences_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Mock stats
  final Map<String, int> _stats = {'Reading': 3, 'Finished': 12, 'Clubs': 4};

  void _navigateToEditProfile(AppUser currentUser) async {
    final result = await Navigator.push<AppUser>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(user: currentUser),
      ),
    );

    if (result != null && mounted) {
      // Update user via API
      try {
        final repository = ref.read(profileRepositoryProvider);
        final updateResult = await repository.updateUser(result);

        updateResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          },
          (updatedUser) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh the user data
            ref.invalidate(currentUserProvider);
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToPreferences(AppUser currentUser) async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreferencesPage(selectedGenres: currentUser.favoriteGenres),
      ),
    );

    if (result != null && mounted) {
      // Update user preferences via API
      final updatedUser = currentUser.copyWith(favoriteGenres: result);
      try {
        final repository = ref.read(profileRepositoryProvider);
        final updateResult = await repository.updateUser(updatedUser);

        updateResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          },
          (user) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preferences updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh the user data
            ref.invalidate(currentUserProvider);
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final repository = ref.read(profileRepositoryProvider);
        final result = await repository.logout();

        result.fold(
          (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          (_) {
            // Invalidate auth state to trigger navigation
            ref.invalidate(authNotifierProvider);

            // Navigate to login page
            if (mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Check if user is authenticated
    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Pallete.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userAsync.when(
        data: (user) => _buildProfileContent(user),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading profile...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Unable to load profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString().contains('Not authenticated')
                      ? 'Your session has expired. Please log in again.'
                      : 'There was an error loading your profile data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(currentUserProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.greenColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Pallete.greenColor,
                        side: BorderSide(color: Pallete.greenColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(AppUser user) {
    return ListView(
      children: [
        // Profile Header
        ProfileHeader(
          user: user,
          onEditPressed: () => _navigateToEditProfile(user),
        ),

        // Stats Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Pallete.whiteColor,
            border: Border(bottom: BorderSide(color: Pallete.borderColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _stats.entries.map((entry) {
              return Column(
                children: [
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Pallete.greenColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Pallete.greyColor,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        // Menu Section
        ProfileMenuSection(
          title: 'LIBRARY',
          children: [
            ProfileMenuTile(
              icon: Icons.library_books_outlined,
              title: 'My Library',
              subtitle: 'View your reading list',
              onTap: () {
                // TODO: Navigate to My Library or BooksPage
              },
            ),
          ],
        ),

        ProfileMenuSection(
          title: 'PREFERENCES',
          children: [
            ProfileMenuTile(
              icon: Icons.category_outlined,
              title: 'Favorite Genres',
              subtitle: user.favoriteGenres.isNotEmpty
                  ? user.favoriteGenres.join(', ')
                  : 'Not set',
              onTap: () => _navigateToPreferences(user),
            ),
          ],
        ),

        ProfileMenuSection(
          title: 'APP',
          children: [
            ProfileMenuTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Notifications, theme, privacy',
              onTap: _navigateToSettings,
            ),
            ProfileMenuTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                // TODO: Navigate to Help page
              },
            ),
            ProfileMenuTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Version 1.0.0',
              onTap: () {
                // TODO: Show about dialog
              },
            ),
          ],
        ),

        // Logout Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.errorColor,
              foregroundColor: Pallete.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
