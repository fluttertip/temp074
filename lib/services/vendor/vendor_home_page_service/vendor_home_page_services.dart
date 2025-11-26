import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/booking_model.dart';

class VendorHomePageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookingModel>> getVendorBookings(String vendorId) async {
    final qs = await _firestore
        .collection('bookings')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .get();

    return qs.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  Stream<List<BookingModel>> watchVendorBookings(String vendorId) {
    return _firestore
        .collection('bookings')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => BookingModel.fromFirestore(d)).toList());
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
