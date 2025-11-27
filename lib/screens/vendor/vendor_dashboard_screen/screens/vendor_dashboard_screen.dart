import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/vendor/vendorhomeprovider/vendor_homepage_provider.dart';
import 'package:homeservice/models/booking_model.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cachedUser = userProvider.getCachedUser();

    if (cachedUser == null) {
      return const Scaffold(
        body: Center(child: Text('No vendor signed in')),
      );
    }

    return ChangeNotifierProvider<VendorHomePageProvider>(
      create: (_) {
        final p = VendorHomePageProvider();
        p.init(cachedUser.uid);
        return p;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Vendor Dashboard')),
        body: Consumer<VendorHomePageProvider>(
          builder: (context, vm, _) {
            final bookings = _applyFilter(vm.bookings, _filter);

            return vm.loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => vm.refresh(cachedUser.uid),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsRow(vm),
                          const SizedBox(height: 12),
                          _buildFilterChips(),
                          const SizedBox(height: 12),
                          Text('Bookings', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          if (bookings.isEmpty)
                            const Center(child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Text('No bookings found'),
                            ))
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookings.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final b = bookings[index];
                                return _buildBookingCard(context, vm, b);
                              },
                            ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  List<BookingModel> _applyFilter(List<BookingModel> list, String filter) {
    if (filter == 'all') return list;
    try {
      final BookingStatus status = BookingStatus.values.firstWhere((s) => s.name == filter);
      return list.where((b) => b.status == status).toList();
    } catch (_) {
      return list;
    }
  }

  Widget _buildStatsRow(VendorHomePageProvider vm) {
    return Row(
      children: [
        Expanded(child: _statCard('Completed', vm.completedCount.toString(), Icons.check_circle, Colors.green)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('Earnings', '₹${vm.totalEarnings.toStringAsFixed(0)}', Icons.attach_money, Colors.indigo)),
        const SizedBox(width: 8),
        Expanded(child: _statCard('Services', vm.totalServicesOffered.toString(), Icons.build, Colors.orange)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = <String>['all'] + BookingStatus.values.map((e) => e.name).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((c) {
          final selected = _filter == c;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(c == 'all' ? 'All' : _prettyStatus(c)),
              selected: selected,
              onSelected: (_) => setState(() => _filter = c),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _prettyStatus(String name) {
    return name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim().capitalize();
  }

  Widget _buildBookingCard(BuildContext context, VendorHomePageProvider vm, BookingModel b) {
    final scheduled = b.scheduledDateTime.toLocal();
    final scheduledText = '${scheduled.day}/${scheduled.month}/${scheduled.year} ${scheduled.hour.toString().padLeft(2, '0')}:${scheduled.minute.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(b.serviceDetails.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                Chip(label: Text(b.status.name)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${b.customerContact.name}'),
            const SizedBox(height: 4),
            Text('When: $scheduledText'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _actionButtonsForStatus(context, vm, b),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _actionButtonsForStatus(BuildContext context, VendorHomePageProvider vm, BookingModel b) {
    final List<Widget> actions = [];
    void doUpdate(BookingStatus status) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm'),
          content: Text('Are you sure you want to mark this booking as ${status.name}?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await vm.updateStatus(b.id, status);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking updated to ${status.name}')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
        }
      }
    }

    switch (b.status) {
      case BookingStatus.pending:
        actions.add(TextButton(onPressed: () => doUpdate(BookingStatus.confirmed), child: const Text('Confirm')));
        actions.add(TextButton(onPressed: () => doUpdate(BookingStatus.rejected), child: const Text('Reject')));
        break;
      case BookingStatus.confirmed:
        actions.add(TextButton(onPressed: () => doUpdate(BookingStatus.inProgress), child: const Text('Start')));
        actions.add(TextButton(onPressed: () => doUpdate(BookingStatus.cancelled), child: const Text('Cancel')));
        break;
      case BookingStatus.inProgress:
        actions.add(TextButton(onPressed: () => doUpdate(BookingStatus.completed), child: const Text('Complete')));
        break;
      default:
        // no actions
        break;
    }

    return actions;
  }
}

extension _StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}