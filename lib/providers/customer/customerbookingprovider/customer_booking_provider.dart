import 'package:homeservice/models/booking_model.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/customer/customer_booking_services/customer_booking_services.dart';

class CustomerBookingProvider extends BaseProvider {
  final BookingService _bookingService = BookingService();
  
  String? _currentBookingId;
  BookingModel? _currentBooking;

  String? get currentBookingId => _currentBookingId;
  BookingModel? get currentBooking => _currentBooking;

  /// Create a new booking
  Future<String?> createBooking({
    required UserModel customer,
    required UserModel vendor,
    required ServiceModel service,
    required DateTime scheduledDateTime,
    required String location,
    double? latitude,
    double? longitude,
    String? bookingNotes,
  }) async {
    setLoading(true);
    clearError();

    try {
      print('🔄 [BookingProvider] Creating booking...');

      // Validate inputs
      if (scheduledDateTime.isBefore(DateTime.now())) {
        throw Exception('Scheduled time must be in the future');
      }

      if (location.isEmpty) {
        throw Exception('Location is required');
      }

      // Create booking
      final bookingId = await _bookingService.createBooking(
        customer: customer,
        vendor: vendor,
        service: service,
        scheduledDateTime: scheduledDateTime,
        location: location,
        latitude: latitude,
        longitude: longitude,
        bookingNotes: bookingNotes,
      );

      _currentBookingId = bookingId;
      print('✅ [BookingProvider] Booking created: $bookingId');
      
      notifyListeners();
      return bookingId;
    } catch (e) {
      print('❌ [BookingProvider] Error creating booking: $e');
      setError('Failed to create booking: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Get booking details
  Future<BookingModel?> getBooking(String bookingId) async {
    setLoading(true);
    clearError();

    try {
      final booking = await _bookingService.getBooking(bookingId);
      _currentBooking = booking;
      notifyListeners();
      return booking;
    } catch (e) {
      print('❌ [BookingProvider] Error getting booking: $e');
      setError('Failed to load booking: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Update booking status
  Future<bool> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    setLoading(true);
    clearError();

    try {
      await _bookingService.updateBookingStatus(bookingId, status);
      
      // Update current booking if it's the same one
      if (_currentBooking?.id == bookingId) {
        _currentBooking = await _bookingService.getBooking(bookingId);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ [BookingProvider] Error updating booking status: $e');
      setError('Failed to update booking: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Watch a booking in real-time
  Stream<BookingModel> watchBooking(String bookingId) {
    return _bookingService.watchBooking(bookingId);
  }

  /// Clear current booking data
  void clearCurrentBooking() {
    _currentBookingId = null;
    _currentBooking = null;
    clearError();
    notifyListeners();
  }

  @override
  void dispose() {
    _currentBookingId = null;
    _currentBooking = null;
    super.dispose();
  }
}