import '../core/icustomer_booking_history_service_interface.dart';
import '../firebase_source/booking_history_firestore_source.dart';
import '../../../../models/booking_model.dart';

class CustomerBookingHistoryServiceImpl implements ICustomerBookingHistoryServiceInterface {
  final BookingHistoryFirestoreSource _firestoreSource;

  CustomerBookingHistoryServiceImpl({
    BookingHistoryFirestoreSource? firestoreSource,
  }) : _firestoreSource = firestoreSource ?? BookingHistoryFirestoreSource();

  @override
  Future<List<BookingModel>> getCustomerBookings(String customerId) async {
    return await _firestoreSource.getCustomerBookings(customerId);
  }

  @override
  Stream<List<BookingModel>> watchCustomerBookings(String customerId) {
    return _firestoreSource.watchCustomerBookings(customerId);
  }
}