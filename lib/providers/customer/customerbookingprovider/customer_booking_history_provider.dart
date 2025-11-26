import 'dart:async';
import 'package:homeservice/models/booking_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/customer/customer_booking_services/customer_booking_history_services.dart';

class CustomerBookingHistoryProvider extends BaseProvider {
  List<BookingModel> _bookings = [];
  StreamSubscription<List<BookingModel>>? _bookingSubscription;
  bool _isInitialized = false;
  String? _currentCustomerId;

  List<BookingModel> get bookings => _bookings;
  bool get isInitialized => _isInitialized;

  /// Get bookings by status
  List<BookingModel> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  /// Get count of bookings by status
  int getBookingsCountByStatus(BookingStatus status) {
    return getBookingsByStatus(status).length;
  }

  /// Load bookings for a customer
  Future<void> loadCustomerBookings(String customerId) async {
    if (customerId.isEmpty) {
      print('❌ [BookingHistoryProvider] Cannot load: customerId is empty');
      return;
    }

    // If already watching this customer, skip
    if (_isInitialized && _currentCustomerId == customerId) {
      print('⏭️ [BookingHistoryProvider] Already watching customer: $customerId');
      return;
    }

    // If watching different customer, reset
    if (_currentCustomerId != null && _currentCustomerId != customerId) {
      print('🔄 [BookingHistoryProvider] Switching to new customer');
      await _bookingSubscription?.cancel();
      _isInitialized = false;
    }

    _currentCustomerId = customerId;
    setLoading(true);
    clearError();

    try {
      print('🔄 [BookingHistoryProvider] Loading bookings for: $customerId');
      
      // Cancel previous subscription if exists
      await _bookingSubscription?.cancel();

      // Start watching in real-time
      _bookingSubscription = CustomerBookingHistoryServices
          .watchCustomerBookings(customerId)
          .listen(
        (bookings) {
          _bookings = bookings;
          _isInitialized = true;
          setLoading(false);
          print('✅ [BookingHistoryProvider] Stream update: ${_bookings.length} bookings');
          notifyListeners();
        },
        onError: (error) {
          print('❌ [BookingHistoryProvider] Stream error: $error');
          setError('Failed to load bookings: $error');
          _isInitialized = true;
          setLoading(false);
          notifyListeners();
        },
      );

      // Initial load (optional, since stream will provide data)
      try {
        final initialBookings = await CustomerBookingHistoryServices
            .getCustomerBookings(customerId);
        _bookings = initialBookings;
        _isInitialized = true;
        print('✅ [BookingHistoryProvider] Initial load: ${_bookings.length} bookings');
        notifyListeners();
      } catch (e) {
        print('⚠️ [BookingHistoryProvider] Initial load failed, waiting for stream: $e');
      }
    } catch (e) {
      print('❌ [BookingHistoryProvider] Error loading bookings: $e');
      setError('Failed to load bookings: $e');
      _isInitialized = true;
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  /// Refresh bookings
  Future<void> refresh() async {
    if (_currentCustomerId == null || _currentCustomerId!.isEmpty) {
      print('⚠️ [BookingHistoryProvider] Cannot refresh: no customer ID');
      return;
    }

    try {
      print('🔄 [BookingHistoryProvider] Refreshing bookings...');
      final bookings = await CustomerBookingHistoryServices
          .getCustomerBookings(_currentCustomerId!);
      _bookings = bookings;
      notifyListeners();
      print('✅ [BookingHistoryProvider] Refreshed: ${_bookings.length} bookings');
    } catch (e) {
      print('❌ [BookingHistoryProvider] Refresh error: $e');
      // Don't update error state during refresh, just log it
    }
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      print('🔄 [BookingHistoryProvider] Cancelling booking: $bookingId');
      await CustomerBookingHistoryServices.cancelBooking(bookingId);
      print('✅ [BookingHistoryProvider] Booking cancelled');
      // Stream will auto-update the UI
      return true;
    } catch (e) {
      print('❌ [BookingHistoryProvider] Cancel error: $e');
      setError('Failed to cancel booking: $e');
      return false;
    }
  }

  /// Clear data and reset
  void clear() {
    print('🧹 [BookingHistoryProvider] Clearing data');
    _bookings.clear();
    _isInitialized = false;
    _currentCustomerId = null;
    clearError();
    _bookingSubscription?.cancel();
    _bookingSubscription = null;
    notifyListeners();
  }

  @override
  void dispose() {
    print('🗑️ [BookingHistoryProvider] Disposing');
    _bookingSubscription?.cancel();
    clear();
    super.dispose();
  }
}