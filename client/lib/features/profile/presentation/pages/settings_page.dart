import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/core/utils/app_colors.dart';
import '../providers/profile_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // TODO: Load actual settings from storage/API
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              currentPasswordController.dispose();
              newPasswordController.dispose();
              confirmPasswordController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                try {
                  final repository = ref.read(profileRepositoryProvider);
                  final result = await repository.changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );

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
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password changed successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  );
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  currentPasswordController.dispose();
                  newPasswordController.dispose();
                  confirmPasswordController.dispose();
                }
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Pallete.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Pallete.blackColor),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader('APPEARANCE'),
          Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(
                top: BorderSide(color: Pallete.borderColor),
                bottom: BorderSide(color: Pallete.borderColor),
              ),
            ),
            child: SwitchListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Pallete.blackColor,
                ),
              ),
              subtitle: const Text(
                'Use dark theme',
                style: TextStyle(fontSize: 13, color: Pallete.greyColor),
              ),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                // TODO: Implement theme switching
              },
              activeColor: Pallete.greenColor,
              secondary: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Pallete.greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dark_mode_outlined,
                  color: Pallete.greenColor,
                  size: 22,
                ),
              ),
            ),
          ),

          // Notifications Section
          _buildSectionHeader('NOTIFICATIONS'),
          Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(
                top: BorderSide(color: Pallete.borderColor),
                bottom: BorderSide(color: Pallete.borderColor),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Push Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Pallete.blackColor,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive push notifications',
                    style: TextStyle(fontSize: 13, color: Pallete.greyColor),
                  ),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    // TODO: Update notification settings
                  },
                  activeColor: Pallete.greenColor,
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Pallete.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Pallete.greenColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Security Section
          _buildSectionHeader('SECURITY'),
          Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(
                top: BorderSide(color: Pallete.borderColor),
                bottom: BorderSide(color: Pallete.borderColor),
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Pallete.greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: Pallete.greenColor,
                  size: 22,
                ),
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Pallete.blackColor,
                ),
              ),
              subtitle: const Text(
                'Update your password',
                style: TextStyle(fontSize: 13, color: Pallete.greyColor),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Pallete.greyColor,
              ),
              onTap: _showChangePasswordDialog,
            ),
          ),

          // Privacy Section
          _buildSectionHeader('PRIVACY'),
          Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(
                top: BorderSide(color: Pallete.borderColor),
                bottom: BorderSide(color: Pallete.borderColor),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Pallete.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.privacy_tip_outlined,
                      color: Pallete.greenColor,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Pallete.blackColor,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Pallete.greyColor,
                  ),
                  onTap: () {
                    // TODO: Navigate to Privacy Policy
                  },
                ),
                Divider(height: 1, color: Pallete.borderColor),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Pallete.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: Pallete.greenColor,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Pallete.blackColor,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Pallete.greyColor,
                  ),
                  onTap: () {
                    // TODO: Navigate to Terms of Service
                  },
                ),
              ],
            ),
          ),

          // About Section
          _buildSectionHeader('ABOUT'),
          Container(
            decoration: BoxDecoration(
              color: Pallete.whiteColor,
              border: Border(
                top: BorderSide(color: Pallete.borderColor),
                bottom: BorderSide(color: Pallete.borderColor),
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Pallete.greenColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outlined,
                  color: Pallete.greenColor,
                  size: 22,
                ),
              ),
              title: const Text(
                'App Version',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Pallete.blackColor,
                ),
              ),
              trailing: const Text(
                '1.0.0',
                style: TextStyle(fontSize: 14, color: Pallete.greyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Pallete.greyColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
