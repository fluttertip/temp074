import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/user_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Navigation after provider state changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (userProvider.isAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/unified-home');
          } else {
            Navigator.of(context).pushReplacementNamed('/google-signin');
          }
        });

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}




// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   Future<void> _initializeApp() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
    
//     // Initialize authentication
//     await userProvider.initializeAuth();
    
//     // Add a minimum splash duration for better UX (optional)
//     await Future.delayed(const Duration(seconds: 1));
    
//     if (!mounted) return;
    
//     // Navigate based on authentication state
//     if (userProvider.isAuthenticated) {

//       Navigator.of(context).pushReplacementNamed('/unified-home');
//     } else {
//       Navigator.of(context).pushReplacementNamed('/google-signin');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Your app logo or icon here
//             // Icon(
//             //   Icons.home_repair_service,
//             //   size: 100,
//             //   color: Theme.of(context).primaryColor,
//             // ),
//             const SizedBox(height: 24),
//             const Text(
//               'Home Service',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 48),
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
