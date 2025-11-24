import 'package:flutter/material.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:homeservice/screens/vendor/vendor_dashboard_screen/widgets/action_card.dart';
import 'package:homeservice/screens/vendor/vendor_dashboard_screen/widgets/activity_item.dart';
import 'package:homeservice/screens/vendor/vendor_dashboard_screen/widgets/stat_card.dart';
import 'package:homeservice/widgets/common_wrapper/exit_confirmation_wrapper.dart';
import 'package:provider/provider.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationWrapper(
      titleMessage: "Exit App",
      contentMessage: "Do you want to exit the app?",
      forceExit: false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Provider Dashboard'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // PopupMenuButton<String>(
            //   icon: const Icon(Icons.more_vert),
            //   onSelected: (value) {
            //     switch (value) {
            //       case 'profile':
            //         Navigator.pushNamed(context, '/vendor/profile');
            //         break;
            //       case 'logout':
            //         VendorDashboardController.showLogoutDialog(context);
            //         break;
            //     }
            //   },
            //   itemBuilder: (context) => [
            //     const PopupMenuItem(
            //       value: 'profile',
            //       child: Row(
            //         children: [
            //           Icon(Icons.person),
            //           SizedBox(width: 8),
            //           Text('Profile'),
            //         ],
            //       ),
            //     ),
            //     const PopupMenuItem(
            //       value: 'logout',
            //       child: Row(
            //         children: [
            //           Icon(Icons.logout),
            //           SizedBox(width: 8),
            //           Text('Logout'),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<VendorProfileProvider>(
                  builder: (context, provider, _) {
                    if (!provider.isVendorProfileComplete &&
                        !provider.isBannerShown('vendor_dashboard')) {
                      provider.markBannerShown('vendor_dashboard');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   showCompleteProfileBanner(
                        //     context,
                        //     "complete your vendor profile to unlock all features",
                        //     onTap: () {},
                        //   );
                        CompleteProfileBannerOverlay.show(
                          context,
                          message:
                              "complete your vendor profile to unlock all features",
                          duration: const Duration(seconds: 5),
                        );
                      });
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade700],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('username later implement',
                                  // 'Welcome back, ${userProvider.userDisplayName}!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Manage your services and bookings',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  ' Stats',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Active Bookings',
                        value: '12',
                        icon: Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Total Earnings',
                        value: 'Rs. 25,000',
                        icon: null,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Services',
                        value: '8',
                        icon: Icons.build,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Rating',
                        value: '4.8',
                        icon: Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  ' Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    ActionCard(
                      title: 'Manage Services',
                      icon: Icons.build,
                      color: Colors.blue,
                      onTap: () =>
                          Navigator.pushNamed(context, '/vendor/services'),
                    ),
                    ActionCard(
                      title: 'Booking Requests',
                      icon: Icons.calendar_today,
                      color: Colors.green,
                      onTap: () =>
                          Navigator.pushNamed(context, '/vendor/bookings'),
                    ),
                    ActionCard(
                      title: 'Earnings',
                      icon: Icons.money_outlined,
                      color: Colors.orange,
                      onTap: () =>
                          Navigator.pushNamed(context, '/vendor/earnings'),
                    ),
                    ActionCard(
                      title: 'Profile',
                      icon: Icons.person,
                      color: Colors.purple,
                      onTap: () =>
                          Navigator.pushNamed(context, '/vendor/profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const ActivityItem(
                  title: 'New booking request for Plumbing service',
                  time: '2 hours ago',
                  icon: Icons.notifications,
                  color: Colors.blue,
                ),
                const ActivityItem(
                  title: 'Payment received for Electrical service',
                  time: '5 hours ago',
                  icon: Icons.payment,
                  color: Colors.green,
                ),
                const ActivityItem(
                  title: 'Service completed - Cleaning service',
                  time: '1 day ago',
                  icon: Icons.check_circle,
                  color: Colors.orange,
                ),

                // //create elevated button with onpressed property
                // const SizedBox(height: 30),
                // Center(
                //   child: ElevatedButton.icon(
                //     icon: const Icon(Icons.settings),
                //     label: const Text(' vendor Settings'),
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 24,
                //         vertical: 12,
                //       ),
                //       textStyle: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const VendorSettingsScreen(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
