import 'package:flutter/material.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/screens/shared/widgets/common_role_switcher_widget.dart';
import 'package:homeservice/screens/shared/widgets/setting_section_widget.dart';
import 'package:provider/provider.dart';

class CustomerSettingsScreen extends StatelessWidget {
  const CustomerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            CommonRoleSwitcherWidget(),
            const SizedBox(height: 20),
// Rewards and Referral Section
            SettingsSectionWidget(
              title: 'Rewards & Referral',
              children: [
                ListTile(
                  leading: const Icon(Icons.card_giftcard),
                  title: const Text('My Rewards'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Refer & Earn'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Settings Section
            SettingsSectionWidget(
              title: 'Settings',
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Address Management'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment Methods'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // App Preferences Section
            SettingsSectionWidget(
              title: 'App Preferences',
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  trailing: const Text('English'),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support Section
            SettingsSectionWidget(
              title: 'Support',
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: const Text('Contact Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About & Legal Section
            SettingsSectionWidget(
              title: 'About & Legal',
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About App'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logout Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
              //rewards and referal

            //setting
            //app preferences
            //support section


            //about 
            //privacy policy


            //logout
          ],
        );
      },
    );
  }
}