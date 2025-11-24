import '../../../../models/booking_model.dart';

abstract class ICustomerBookingHistoryServiceInterface {
  Future<List<BookingModel>> getCustomerBookings(String customerId);

  Stream<List<BookingModel>> watchCustomerBookings(String customerId);
}
