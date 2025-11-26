import 'package:flutter/material.dart';
// import 'package:homeservice/hardcodedseeder.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/providers/customer/customerbookingprovider/customer_booking_history_provider.dart';
import 'package:homeservice/providers/customer/customerbookingprovider/customer_booking_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/banner_images_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/local_expert_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/popular_service_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/recommended_service_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/top_services_provider.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/advance_searchbar_provider.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/static_searchbaranim_provider.dart';
import 'package:homeservice/providers/customer/customerprofileprovider/customer_profile_provider.dart';
import 'package:homeservice/providers/location/location_provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/vendor_services_provider.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // //
  // //  //seeding
  // final seeder = CompleteServiceSeeder();
  // await seeder.seed();
  // // //statistics
  // await seeder.seedAndShowStats();
  // //
  // //
  runApp(const NepFixApp());
}

// class NepFixApp extends StatelessWidget {
//   const NepFixApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => BaseProvider()),
//         ChangeNotifierProvider(create: (_) => LocationProvider()),

//         //authentication providers
//         ChangeNotifierProvider(create: (_) => UserProvider()),
       
//         //customer providers
//         ChangeNotifierProvider(create: (_) => BannerImageProvider()),
//         ChangeNotifierProvider(create: (_) => LocalExpertProvider()),
//         ChangeNotifierProvider(create: (_) => RecommendedServiceProvider()),
//         ChangeNotifierProvider(create: (_) => PopularServiceProvider()),
//         ChangeNotifierProvider(create: (_) => TopServiceProvider()),
//         ChangeNotifierProvider(create: (_) => StaticSearchBarAnimProvider()),
//         ChangeNotifierProvider(create: (_) => CustomerAdvanceSearchProvider()),
//          // CustomerProfileProvider depends on UserProvider
//       ChangeNotifierProxyProvider<UserProvider, CustomerProfileProvider>(
//         create: (context) => CustomerProfileProvider(),
//         update: (context, userProvider, previous) {
//           // Update the CustomerProfileProvider with the latest UserProvider
//           final provider = previous ?? CustomerProfileProvider();
//           provider.updateUserProvider(userProvider);
//           return provider;
//         },
//       ),
//       ChangeNotifierProvider(create: (_) => CustomerBookingHistoryProvider()),
//        ChangeNotifierProvider(create: (_) => CustomerBookingProvider()),
   
       
//        //verndor providers
//         ChangeNotifierProvider(create: (_) => VendorServicesProvider()),
//         ChangeNotifierProxyProvider<UserProvider, VendorProfileProvider>(
//           create: (_) => VendorProfileProvider(),
//           update: (context, userProvider, previousVendorProvider) {
//             final vendorProvider =
//                 previousVendorProvider ?? VendorProfileProvider();
//             vendorProvider.updateUserProvider(userProvider);
//             return vendorProvider;
//           },
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'NepFix Home Services',
//         color: Colors.transparent,
//         initialRoute: AppRoutes.splash,
//         routes: AppRoutes.routes,
//       ),
//     );
//   }
// }


class NepFixApp extends StatelessWidget {
  const NepFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaseProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // customer providers
        ChangeNotifierProvider(create: (_) => BannerImageProvider()),
        ChangeNotifierProvider(create: (_) => LocalExpertProvider()),
        ChangeNotifierProvider(create: (_) => RecommendedServiceProvider()),
        ChangeNotifierProvider(create: (_) => PopularServiceProvider()),
        ChangeNotifierProvider(create: (_) => TopServiceProvider()),
        ChangeNotifierProvider(create: (_) => StaticSearchBarAnimProvider()),
        ChangeNotifierProvider(create: (_) => CustomerAdvanceSearchProvider()),

        ChangeNotifierProxyProvider<UserProvider, CustomerProfileProvider>(
          create: (context) => CustomerProfileProvider(),
          update: (context, userProvider, previous) {
            final provider = previous ?? CustomerProfileProvider();
            provider.updateUserProvider(userProvider);
            return provider;
          },
        ),

        ChangeNotifierProvider(create: (_) => CustomerBookingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => CustomerBookingProvider()),

        // vendor
        ChangeNotifierProvider(create: (_) => VendorServicesProvider()),
        ChangeNotifierProxyProvider<UserProvider, VendorProfileProvider>(
          create: (_) => VendorProfileProvider(),
          update: (context, userProvider, previousVendorProvider) {
            final vendorProvider =
                previousVendorProvider ?? VendorProfileProvider();
            vendorProvider.updateUserProvider(userProvider);
            return vendorProvider;
          },
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NepFix Home Services',
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,

            // IMPORTANT → This forces mobile view in Desktop/Web
            builder: (context, child) {
              if (isMobile) return child!; // normal mobile rendering

              // DESKTOP / WEB MOCKUP SCREEN
              return Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F0F1E),
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F0F1E),
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                  child: Row(
                    children: [
                      // LEFT: message
                      Expanded(
                        child: Center(
                          child: Text("zoom out to 67% for better view",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // CENTER: phone mockup
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: _PhoneMockup(child: child!),
                        ),
                      ),

                      // RIGHT EMPTY SPACE (optional info)
                      const Expanded(child: SizedBox()),
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



class _PhoneMockup extends StatelessWidget {
  final Widget child;
  const _PhoneMockup({required this.child});

  @override
  Widget build(BuildContext context) {
    const frameWidth = 440.0;
    const frameHeight = 920.0;

    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withOpacity(0.25),
              blurRadius: 40.0,
              offset: const Offset(-10, 10),
            ),
            BoxShadow(
              color: const Color(0xFF764BA2).withOpacity(0.25),
              blurRadius: 40.0,
              offset: const Offset(10, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2C2C3E),
                    Color(0xFF1C1C2E),
                    Color(0xFF0F0F1E),
                  ],
                ),
                border: Border.all(width: 12.0, color: Color(0xFF1A1A2E)),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38.0),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
