import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:homeservice/models/booking_model.dart';
import 'package:homeservice/services/vendor/vendor_home_page_service/vendor_home_page_services.dart';

class VendorHomePageProvider extends ChangeNotifier {
  final VendorHomePageServices _service = VendorHomePageServices();
  StreamSubscription<List<BookingModel>>? _sub;

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  Future<void> init(String vendorId, {bool watch = true}) async {
    print('🚀 [VendorProvider] Initializing with vendorId: $vendorId');
    print('   watch mode: $watch');
    _setLoading(true);
    try {
      print('   📞 Calling getVendorBookings...');
      _bookings = await _service.getVendorBookings(vendorId);
      print('📋 [VendorProvider] Loaded ${_bookings.length} bookings');
      print('   📊 Booking counts: ${counts}');
      notifyListeners();

      if (watch) {
        _sub?.cancel();
        print('   👁️ Setting up stream watch...');
        _sub = _service.watchVendorBookings(vendorId).listen((list) {
          print('👀 [VendorProvider] Stream update: ${list.length} bookings');
          _bookings = list;
          notifyListeners();
        }, onError: (e, st) {
          print('❌ [VendorProvider] Stream error: $e');
          print('Stack: $st');
        });
      }
    } catch (e, st) {
      print('❌ [VendorProvider] Error during init: $e');
      print('Stack: $st');
      _bookings = [];
    } finally {
      _setLoading(false);
      print('🏁 [VendorProvider] Init complete');
    }
  }

  Future<void> refresh(String vendorId) async => init(vendorId, watch: false);

  Map<BookingStatus, int> get counts {
    final map = <BookingStatus, int>{};
    for (var s in BookingStatus.values) {
      map[s] = 0;
    }
    for (var b in _bookings) {
      map[b.status] = (map[b.status] ?? 0) + 1;
    }
    return map;
  }

  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    await _service.updateBookingStatus(bookingId, status);
  }

  /// Total earnings from completed and paid bookings
  double get totalEarnings {
    double sum = 0.0;
    for (var b in _bookings) {
      try {
        if (b.status == BookingStatus.completed && b.isPaymentCompleted) {
          sum += b.pricing.finalPrice;
        }
      } catch (_) {}
    }
    return sum;
  }

  /// Number of completed bookings
  int get completedCount => counts[BookingStatus.completed] ?? 0;

  /// Number of unique services this vendor has in bookings (simple metric)
  int get totalServicesOffered {
    try {
      final ids = _bookings.map((b) => b.serviceDetails.serviceId).toSet();
      return ids.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
