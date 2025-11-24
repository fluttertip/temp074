// import 'package:flutter/material.dart';
// import 'package:homeservice/providers/auth/google_provider.dart';
// import 'package:homeservice/providers/auth/user_provider.dart';
// import 'package:provider/provider.dart';

// class VendorDashboardController {
//   static void showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 Future.microtask(() async {
//                   final userProvider = Provider.of<UserProvider>(
//                     context,
//                     listen: false,
//                   );

//                   final googleProvider = Provider.of<GoogleProvider>(
//                     context,
//                     listen: false,
//                   );

//                   await googleProvider.signOut(userProvider);

//                   if (context.mounted) {
//                     Navigator.pushReplacementNamed(context, '/');
//                   }
//                 });
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
