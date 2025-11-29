import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/booking_model.dart';

class VendorHomePageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookingModel>> getVendorBookings(String vendorId) async {
    print('🔄 [VendorService] Fetching bookings for vendorId: $vendorId');
    try {
      final qs = await _firestore
          .collection('bookings')
          .where('vendorId', isEqualTo: vendorId)
          .orderBy('createdAt', descending: true)
          .get();

      print('✅ [VendorService] Query returned ${qs.docs.length} bookings');
      final bookings = <BookingModel>[];
      for (var doc in qs.docs) {
        try {
          final data = doc.data();
          print('  📄 Doc ${doc.id} raw data keys: ${data.keys.toList()}');
          print('  📄 Status value: ${data['status']} (type: ${data['status'].runtimeType})');
          
          final b = BookingModel.fromFirestore(doc);
          bookings.add(b);
          print('  ✓ Parsed booking: ${doc.id} - ${b.serviceDetails.title} (${b.status.name})');
        } catch (e, st) {
          print('  ✗ Error parsing booking ${doc.id}: $e');
          print('  Stack: $st');
        }
      }
      print('📦 [VendorService] Successfully parsed ${bookings.length} bookings');
      return bookings;
    } catch (e, st) {
      print('❌ [VendorService] Error fetching bookings: $e');
      print('Stack: $st');
      return [];
    }
  }

  Stream<List<BookingModel>> watchVendorBookings(String vendorId) {
    return _firestore
        .collection('bookings')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((e) {
          print('❌ [VendorService] Stream error: $e');
          return <QuerySnapshot>[];
        })
        .map((snap) {
          try {
            final bookings = snap.docs.map((d) {
              try {
                return BookingModel.fromFirestore(d);
              } catch (e) {
                print('  ✗ Error parsing stream booking ${d.id}: $e');
                rethrow;
              }
            }).toList();
            print('👀 [VendorService] Stream mapped ${bookings.length} bookings');
            return bookings;
          } catch (e) {
            print('❌ [VendorService] Error mapping stream: $e');
            return [];
          }
        });
  }

  Future<List<BookingModel>> getBookingsByStatus(String vendorId, BookingStatus status) async {
    final qs = await _firestore
        .collection('bookings')
        .where('vendorId', isEqualTo: vendorId)
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .get();

    return qs.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    final updateData = {
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };

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
      case BookingStatus.pending:
        break;
    }

    await _firestore.collection('bookings').doc(bookingId).update(updateData);
  }
}
