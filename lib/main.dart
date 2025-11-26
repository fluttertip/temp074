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

class NepFixApp extends StatelessWidget {
  const NepFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaseProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),

        //authentication providers
        ChangeNotifierProvider(create: (_) => UserProvider()),
       
        //customer providers
        ChangeNotifierProvider(create: (_) => BannerImageProvider()),
        ChangeNotifierProvider(create: (_) => LocalExpertProvider()),
        ChangeNotifierProvider(create: (_) => RecommendedServiceProvider()),
        ChangeNotifierProvider(create: (_) => PopularServiceProvider()),
        ChangeNotifierProvider(create: (_) => TopServiceProvider()),
        ChangeNotifierProvider(create: (_) => StaticSearchBarAnimProvider()),
        ChangeNotifierProvider(create: (_) => CustomerAdvanceSearchProvider()),
         // CustomerProfileProvider depends on UserProvider
      ChangeNotifierProxyProvider<UserProvider, CustomerProfileProvider>(
        create: (context) => CustomerProfileProvider(),
        update: (context, userProvider, previous) {
          // Update the CustomerProfileProvider with the latest UserProvider
          final provider = previous ?? CustomerProfileProvider();
          provider.updateUserProvider(userProvider);
          return provider;
        },
      ),
      ChangeNotifierProvider(create: (_) => CustomerBookingHistoryProvider()),
       ChangeNotifierProvider(create: (_) => CustomerBookingProvider()),
   
       
       //verndor providers
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NepFix Home Services',
        color: Colors.transparent,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
