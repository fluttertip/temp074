import 'package:flutter/material.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/customer/customerprofileprovider/customer_profile_provider.dart';
import '../components/profile_header.dart';
import '../components/profile_info_section.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return Consumer<CustomerProfileProvider>(
            builder: (context, customerprofileprovider, _) {
              if (customerprofileprovider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (customerprofileprovider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        customerprofileprovider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          customerprofileprovider.refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (customerprofileprovider.user == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No user data found'),
                    ],
                  ),
                );
              }
              if (!customerprofileprovider.isCustomerProfileComplete &&
                  !customerprofileprovider.isBannerShown('customer_profile')) {
                customerprofileprovider.markBannerShown('customer_profile');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  CompleteProfileBannerOverlay.show(
                    context,
                    message:
                        "Fill up Name and Address to complete your profile",
                    duration: const Duration(seconds: 5),
                  );
                });
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (userProvider.isAuthenticated &&
                      userProvider.getCachedUser() != null) {
                    await customerprofileprovider.refresh();
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const ProfileHeader(),
                      const SizedBox(height: 16),
                      const ProfileInfoSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
