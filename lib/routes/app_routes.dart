import 'package:flutter/material.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/screens/auth/google_signin_screen.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/screens/customer_advanced_search_screen.dart';
import 'package:homeservice/screens/customer/customer_booking_screen/screens/customer_booking_history_screen.dart';
import 'package:homeservice/screens/customer/customer_booking_screen/screens/customer_booking_success_screen.dart';
import 'package:homeservice/screens/customer/customer_booking_screen/screens/customer_intermediate_booking_screen.dart';
import 'package:homeservice/screens/customer/customer_profilepage_screen/screens/customer_profile_screen.dart';
import 'package:homeservice/screens/customer/customer_service_detail_page/screens/customer_service_detail_screen.dart';
import 'package:homeservice/screens/shared/components/common_unified_home_screen.dart';
import 'package:homeservice/screens/shared/widgets/common_error_message_screen.dart';
import 'package:homeservice/screens/start/splash_screen.dart';
import 'package:homeservice/screens/vendor/vendor_services_screen/screens/add_vendor_services_screen.dart';
import 'package:homeservice/screens/vendor/vendor_services_screen/screens/edit_vendor_services_screen.dart';
import 'package:homeservice/screens/vendor/vendor_services_screen/screens/vendor_services_screen.dart';

class AppRoutes {
  //auth routes
  static const String splash = '/';
  static const String GoogleSignIn = '/google-signin';

  //main entry point routes after auth
  static const String unifiedHome = '/unified-home';

  //customer routes
  static const String customerHome = '/customer/home';
  static const String customerBookingHistory = '/customer/booking/history';
  static const String customerProfile = '/customer/profile';
  static const String customerAdvanceSearch = '/customer/advanced-search';
  static const String customerServiceDetail = '/customer/service-detail';
  static const String customerIntermediateBooking ='/customer/booking/intermediate';
  static const String customerBookingSuccess = '/customer/booking/success';

  //vendor routes
  static const String vendorHome = '/vendor/home';
  static const String vendorServices = '/vendor/services';
  static const String addVendorService = '/vendor/add-service';
  static const String editVendorService = '/vendor/edit-service';

  static Map<String, WidgetBuilder> get routes => {

    splash: (context) => SplashScreen(),

    GoogleSignIn: (context) => const GoogleSignInScreen(),

    unifiedHome: (context) => const UnifiedHomeScreen(),

    //customer routes
    customerHome: (context) => const UnifiedHomeScreen(),
    customerBookingHistory: (context) => const CustomerBookingHistoryScreen(),
    customerAdvanceSearch: (context) => CustomerAdvancedSearchScreen(),
    customerProfile: (context) => const CustomerProfileScreen(),
    customerServiceDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! ServiceWithProviderModel) {
        return const CommonMessageScreen(
          message: 'Invalid or missing service data',
          icon: Icons.error_outline,
        );
      }
      return CustomerServiceDescriptionPage(
        service: args.service,
        vendorData: args.provider,
      );
    },
       customerIntermediateBooking: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! Map<String, dynamic>) {
        return const CommonMessageScreen(
          message: 'Invalid booking data',
          icon: Icons.error_outline,
        );
      }
      return const IntermediateBookingScreen();
    },

    customerBookingSuccess: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! Map<String, dynamic>) {
        return const CommonMessageScreen(
          message: 'Invalid booking confirmation data',
          icon: Icons.error_outline,
        );
      }
      return const BookingSuccessScreen();
    },



    //vendor routes
    vendorHome: (context) => const UnifiedHomeScreen(),
    vendorServices: (context) => const VendorServicesScreen(),
    addVendorService: (context) => const AddVendorServicesScreen(),
    editVendorService: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as ServiceModel;
      return EditVendorServicesScreen(service: args);
    },
  };
}
