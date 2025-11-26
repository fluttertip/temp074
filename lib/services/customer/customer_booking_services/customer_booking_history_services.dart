import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/booking_model.dart';

class CustomerBookingHistoryServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all bookings for a customer (one-time fetch)
  static Future<List<BookingModel>> getCustomerBookings(String customerId) async {
    try {
      print('🔄 [BookingHistoryService] Fetching bookings for customer: $customerId');
      
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      final bookings = querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();

      print('✅ [BookingHistoryService] Found ${bookings.length} bookings');
      return bookings;
    } catch (e) {
      print('❌ [BookingHistoryService] Error fetching bookings: $e');
      rethrow;
    }
  }

  /// Watch customer bookings in real-time
  static Stream<List<BookingModel>> watchCustomerBookings(String customerId) {
    print('👀 [BookingHistoryService] Watching bookings for customer: $customerId');
    
    return _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final bookings = snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc))
              .toList();
          
          print('📦 [BookingHistoryService] Stream update: ${bookings.length} bookings');
          return bookings;
        });
  }

  /// Get bookings by status
  static Future<List<BookingModel>> getBookingsByStatus(
    String customerId,
    BookingStatus status,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('customerId', isEqualTo: customerId)
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ [BookingHistoryService] Error fetching bookings by status: $e');
      rethrow;
    }
  }

  /// Cancel a booking
  static Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
        'timeline.cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ [BookingHistoryService] Booking cancelled: $bookingId');
    } catch (e) {
      print('❌ [BookingHistoryService] Error cancelling booking: $e');
      rethrow;
    }
  }
}