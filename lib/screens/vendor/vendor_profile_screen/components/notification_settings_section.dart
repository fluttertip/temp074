import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/notification_settings_provider.dart';

class NotificationSettingsSection extends StatelessWidget {
  const NotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationSettingsProvider(),
      child: const _NotificationSettingsBody(),
    );
  }
}

class _NotificationSettingsBody extends StatelessWidget {
  const _NotificationSettingsBody();

  @override
  Widget build(BuildContext context) {
    return Consumer2<VendorProfileProvider, NotificationSettingsProvider>(
      builder: (context, vendorProvider, notificationProvider, _) {
        final user = vendorProvider.user;
        final notificationSettings = user?.notificationSettings ?? {};
        final preferences = user?.preferences ?? {};

        // load existing data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!notificationProvider.isInitialized && user != null) {
            notificationProvider.initializeSettings(
              email: notificationSettings['email'] ?? true,
              push: notificationSettings['push'] ?? true,
              online: preferences['showOnline'] ?? true,
            );
          }
        });

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.indigo.shade600.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification Settings',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Manage how you receive notifications',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Online Status
                _buildSettingTile(
                  title: 'Show Online Status',
                  subtitle:
                      'Let customers see when you\'re available for bookings',
                  icon: Icons.online_prediction_outlined,
                  value: notificationProvider.showOnline,
                  onChanged: notificationProvider.updateShowOnline,
                  activeColor: Colors.green,
                ),

                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                _buildSettingTile(
                  title: 'Email Notifications',
                  subtitle:
                      'Receive booking updates and important messages via email',
                  icon: Icons.email_outlined,
                  value: notificationProvider.emailNotifications,
                  onChanged: notificationProvider.updateEmailNotifications,
                  activeColor: Colors.blue,
                ),

                const SizedBox(height: 16),

                _buildSettingTile(
                  title: 'Push Notifications',
                  subtitle:
                      'Get instant notifications on your device for new bookings',
                  icon: Icons.phone_android_outlined,
                  value: notificationProvider.pushNotifications,
                  onChanged: notificationProvider.updatePushNotifications,
                  activeColor: Colors.purple,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: notificationProvider.isLoading
                        ? null
                        : () => _updateNotificationSettings(
                            context,
                            notificationProvider,
                            vendorProvider,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: notificationProvider.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Update Notification Settings',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? activeColor.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? activeColor.withOpacity(0.3) : Colors.grey.shade200,
          width: value ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: value
                  ? activeColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: value ? activeColor : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value ? Colors.black87 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: activeColor,
              activeTrackColor: activeColor.withOpacity(0.3),
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNotificationSettings(
    BuildContext context,
    NotificationSettingsProvider notificationProvider,
    VendorProfileProvider vendorProvider,
  ) async {
    notificationProvider.setLoading(true);

    try {
      await vendorProvider.updateNotificationSettings(
        notificationProvider.getNotificationSettings(),
      );

      await vendorProvider.updatePreferences(
        notificationProvider.getPreferences(),
      );

      _showSnackBar(context, 'Notification settings updated successfully!');
    } catch (e) {
      _showSnackBar(
        context,
        'Failed to update notification settings',
        isError: true,
      );
    } finally {
      notificationProvider.setLoading(false);
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
