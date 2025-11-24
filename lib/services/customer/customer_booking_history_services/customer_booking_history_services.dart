import 'core/icustomer_booking_history_service_interface.dart';
import 'impl/customer_booking_history_service_impl.dart';
import '../../../models/booking_model.dart';

class CustomerBookingHistoryServices {
  static final ICustomerBookingHistoryServiceInterface _service = 
      CustomerBookingHistoryServiceImpl();

  static Future<List<BookingModel>> getCustomerBookings(String customerId) {
    return _service.getCustomerBookings(customerId);
  }

  static Stream<List<BookingModel>> watchCustomerBookings(String customerId) {
    return _service.watchCustomerBookings(customerId);
  }
}