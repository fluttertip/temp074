import 'package:flutter/material.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/navigation/role_navigation_provider.dart';
import '../../customer/customer_home_screen/customer_home_screen.dart';
import '../../vendor/vendor_home_screen/vendor_home_screen.dart';
import '../../../widgets/common_wrapper/exit_confirmation_wrapper.dart';

class UnifiedHomeScreen extends StatelessWidget {
  const UnifiedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Show loading state
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show error state
        if (userProvider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${userProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await userProvider.initializeAuth();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final activeRole = userProvider.activeRole;
        final user = userProvider.getCachedUser();

        // Null safety checks
        if (activeRole == null || user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        print('📱 UnifiedHomeScreen: Building UI for role = $activeRole');

        // Create a new navigation provider for each role change
        // Key is CRITICAL - it forces a complete rebuild when role changes
        return ChangeNotifierProvider(
          key: ValueKey('nav_provider_$activeRole'),
          create: (_) {
            print('🆕 Creating new RoleNavigationProvider for $activeRole');
            return RoleNavigationProvider();
          },
          child: Consumer<RoleNavigationProvider>(
            builder: (context, navProvider, child) {
              print(
                '🔍 Building content for role: $activeRole, index: ${navProvider.currentIndex}',
              );

              return ExitConfirmationWrapper(
                titleMessage: "Exit App",
                contentMessage: "Do you want to exit the app?",
                forceExit: false,
                child: Scaffold(
                  body: _buildRoleBasedContent(
                    activeRole,
                    navProvider.currentIndex,
                  ),
                  bottomNavigationBar: _buildBottomNavigation(
                    context,
                    activeRole,
                    navProvider,
                    userProvider,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRoleBasedContent(String activeRole, int currentIndex) {
    // Safety check for index bounds
    final maxIndex = 3; 
    final safeIndex = currentIndex > maxIndex ? 0 : currentIndex;

    if (activeRole == 'vendor') {
      return VendorHomeScreen(currentIndex: safeIndex);
    } else {
      return CustomerHomeScreen(currentIndex: safeIndex);
    }
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    String activeRole,
    RoleNavigationProvider navProvider,
    UserProvider userProvider,
  ) {
    final items = _getNavItems(activeRole);

    // Ensure current index is within bounds
    final currentIndex =
        navProvider.currentIndex < items.length ? navProvider.currentIndex : 0;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) =>
          _handleNavTap(context, index, navProvider, userProvider),
      selectedItemColor: _getThemeColorForRole(activeRole),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: items,
    );
  }

  List<BottomNavigationBarItem> _getNavItems(String activeRole) {
    if (activeRole == 'vendor') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    }
  }

  Color _getThemeColorForRole(String activeRole) {
    return activeRole == 'vendor' ? Colors.green : Colors.blue;
  }

  void _handleNavTap(
    BuildContext context,
    int index,
    RoleNavigationProvider navProvider,
    UserProvider userProvider,
  ) {
    navProvider.changeIndex(index);
  }
}
