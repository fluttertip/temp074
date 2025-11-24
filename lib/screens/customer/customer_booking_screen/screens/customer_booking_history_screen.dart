import 'package:flutter/material.dart';
import '../../../../models/booking_model.dart';


class CustomerBookingHistoryScreen extends StatefulWidget {
  const CustomerBookingHistoryScreen({super.key});

  @override
  State<CustomerBookingHistoryScreen> createState() =>
      _CustomerBookingHistoryScreenState();
}

class _CustomerBookingHistoryScreenState
    extends State<CustomerBookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<BookingStatus> _tabs = [
    BookingStatus.pending,
    BookingStatus.confirmed,
    BookingStatus.inProgress,
    BookingStatus.completed,
    BookingStatus.cancelled,
    BookingStatus.rejected,
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: _tabs.length, vsync: this);
  //   WidgetsBinding.instance.addPostFrameCallback((_) => _loadBookings());
  // }

  // void _loadBookings() {
  //   final userProvider = context.read<UserProvider>();
  //   final bookingProvider = context.read<CustomerBookingHistoryProvider>();
  //   bookingProvider.loadCustomerBookings(userProvider.uid);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('My Bookings'),
      //   bottom: TabBar(
      //     controller: _tabController,
      //     isScrollable: true,
      //     tabs: _tabs.map((status) => _buildTab(status)).toList(),
      //   ),
      // ),
      // body: Consumer<CustomerBookingHistoryProvider>(
      //   builder: (context, provider, _) {
      //     if (provider.isLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     if (provider.error != null) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Icon(Icons.error_outline, size: 64, color: Colors.red),
      //             const SizedBox(height: 16),
      //             Text('Error: ${provider.error}'),
      //             const SizedBox(height: 16),
      //             ElevatedButton(
      //               onPressed: _loadBookings,
      //               child: const Text('Retry'),
      //             ),
      //           ],
      //         ),
      //       );
      //     }

      //     return TabBarView(
      //       controller: _tabController,
      //       children: _tabs
      //           .map((status) => _buildBookingList(status, provider))
      //           .toList(),
      //     );
      //   },
      // ),
    );
  }

  // Widget _buildTab(BookingStatus status) {
  //   return Consumer<CustomerBookingHistoryProvider>(
  //     builder: (context, provider, _) {
  //       final count = provider.getBookingsCountByStatus(status);
  //       return Tab(
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(_getStatusLabel(status)),
  //             if (count > 0) ...[
  //               const SizedBox(width: 8),
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 6,
  //                   vertical: 2,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: _getStatusColor(status),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Text(
  //                   count.toString(),
  //                   style: const TextStyle(color: Colors.white, fontSize: 10),
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildBookingList(
  //   BookingStatus status,
  //   CustomerBookingHistoryProvider provider,
  // ) {
  //   final bookings = provider.getBookingsByStatus(status);

  //   if (bookings.isEmpty) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(_getStatusIcon(status), size: 64, color: Colors.grey),
  //           const SizedBox(height: 16),
  //           Text('No ${_getStatusLabel(status).toLowerCase()} bookings'),
  //         ],
  //       ),
  //     );
  //   }

  //   return RefreshIndicator(
  //     onRefresh: () => provider.refresh(),
  //     child: ListView.builder(
  //       padding: const EdgeInsets.all(16),
  //       itemCount: bookings.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(bottom: 12),
  //           // child: CustomerBookingHistoryCardComponent(
  //           //   booking: bookings[index],
  //           // ),
  //         );
  //       },
  //     ),
  //   );
  // }

  String _getStatusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.inProgress:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.purple;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.rejected:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline;
      case BookingStatus.inProgress:
        return Icons.work_outline;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
      case BookingStatus.rejected:
        return Icons.block;
    }
  }
}
