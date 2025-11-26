import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/booking_model.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/user_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createBooking({
    required UserModel customer,
    required UserModel vendor,
    required ServiceModel service,
    required DateTime scheduledDateTime,
    required String location,
    double? latitude,
    double? longitude,
    String? bookingNotes,
  }) async {
    try {
      print('🔄 [BookingService] Creating booking...');

      // // Parse service price

        double servicePrice = 0.0;
      final dynamic rawPrice = service.price;
      if (rawPrice == null) {
        servicePrice = 0.0;
      } else if (rawPrice is num) {
        servicePrice = rawPrice.toDouble();
      } else {
        servicePrice = double.tryParse(rawPrice.toString()) ?? 0.0;
      }
      if (servicePrice == 0.0) {
        print('⚠️ [BookingService] Parsed service price is 0.0 (raw: $rawPrice)');
    }
      // double servicePrice;
      // try {
      //   servicePrice = double.parse(service.price as String);
      // } catch (e) {
      //   print('⚠️ [BookingService] Could not parse price: ${service.price}, using 0.0');
      //   servicePrice = 0.0;
      // }

      // Create booking data
      final bookingData = {
        'customerId': customer.uid,
        'vendorId': vendor.uid,
        'status': BookingStatus.pending.name,
        'scheduledDateTime': Timestamp.fromDate(scheduledDateTime),
        'bookingNotes': bookingNotes,
        'serviceDetails': {
          'serviceId': service.id,
          'title': service.title,
          'imageUrl': service.imageUrl,
          'address': location,
          if (latitude != null && longitude != null)
            'coordinates': {
              'lat': latitude,
              'lng': longitude,
            },
          'additionalInfo': bookingNotes,
        },
        'pricing': {
          'basePrice': servicePrice,
          'finalPrice': servicePrice,
          'discount': 0.0,
        },
        'agreementStatus': false,
        'customerContact': {
          'name': customer.name,
          'phone': '', // No phone number as per requirement
        },
        'vendorContact': {
          'name': vendor.name,
          'phone': '', // No phone number as per requirement
        },
        'timeline': {
          'requestedAt': FieldValue.serverTimestamp(),
        },
        'isPaymentCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Create booking document
      final docRef = await _firestore.collection('bookings').add(bookingData);

      print('✅ [BookingService] Booking created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ [BookingService] Error creating booking: $e');
      rethrow;
    }
  }

  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      final updateData = {
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add timestamp fields based on status
      switch (status) {
        case BookingStatus.confirmed:
          updateData['timeline.confirmedAt'] = FieldValue.serverTimestamp();
          break;
        case BookingStatus.inProgress:
          updateData['timeline.startedAt'] = FieldValue.serverTimestamp();
          break;
        case BookingStatus.completed:
          updateData['timeline.completedAt'] = FieldValue.serverTimestamp();
          break;
        case BookingStatus.cancelled:
        case BookingStatus.rejected:
          updateData['timeline.cancelledAt'] = FieldValue.serverTimestamp();
          break;
        default:
          break;
      }

      await _firestore.collection('bookings').doc(bookingId).update(updateData);
      print('✅ [BookingService] Booking status updated to $status');
    } catch (e) {
      print('❌ [BookingService] Error updating booking status: $e');
      rethrow;
    }
  }

  Future<BookingModel?> getBooking(String bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (doc.exists) {
        return BookingModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ [BookingService] Error getting booking: $e');
      rethrow;
    }
  }

  Stream<BookingModel> watchBooking(String bookingId) {
    return _firestore
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map((doc) => BookingModel.fromFirestore(doc));
  }
}