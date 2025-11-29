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
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final cachedUser = userProvider.getCachedUser();
        print('🔐 [Dashboard] UserProvider check:');
        print('   isAuthenticated: ${userProvider.isAuthenticated}');
        print('   activeRole: ${userProvider.activeRole}');
        print('   cachedUser: ${cachedUser?.uid} / ${cachedUser?.name}');

        if (cachedUser == null) {
          print('❌ [Dashboard] No cached user available!');
          return const Scaffold(
            body: Center(child: Text('No vendor signed in')),
          );
        }

        print('✅ [Dashboard] Using vendor ID: ${cachedUser.uid}');
        return _buildDashboard(context, cachedUser);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, dynamic cachedUser) {

    return ChangeNotifierProvider<VendorHomePageProvider>(
      create: (_) {
        final p = VendorHomePageProvider();
        print('📱 [Dashboard] Creating provider for vendor: ${cachedUser.uid}');
        p.init(cachedUser.uid);
        return p;
      },
      child: Scaffold(
        body: Consumer<VendorHomePageProvider>(
          builder: (context, vm, _) {
            print('🎨 [Dashboard] Consumer rebuild:');
            print('   Bookings: ${vm.bookings.length}');
            print('   Loading: ${vm.loading}');
            print('   Filter: $_filter');
            final bookings = _applyFilter(vm.bookings, _filter);

            if (vm.loading) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Loading bookings...'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
                    onRefresh: () async => vm.refresh(cachedUser.uid),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // VENDOR PROFILE HEADER
                          Consumer<UserProvider>(
                            builder: (context, userProvider, _) {
                              final vendor = userProvider.getCachedUser();
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundImage: vendor?.profilePhotoUrl != null
                                            ? NetworkImage(vendor!.profilePhotoUrl!)
                                            : null,
                                        backgroundColor: Colors.grey[300],
                                        child: vendor?.profilePhotoUrl == null
                                            ? Icon(Icons.person, size: 32, color: Colors.grey[600])
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vendor?.name ?? 'Vendor',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              vendor?.email ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.green[100],
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                vendor?.isprofilecompletevendor == true ? 'Profile Complete' : 'Incomplete Profile',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.green[800],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // DEBUG INFO uncomment to debug
                          // Container(
                          //   padding: const EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue[50],
                          //     border: Border.all(color: Colors.blue),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'Vendor UID: ${cachedUser.uid}',
                          //         style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                          //       ),
                          //       Text(
                          //         'Bookings: ${vm.bookings.length} loaded, ${bookings.length} after filter',
                          //         style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                          //       ),
                          //       Text(
                          //         'Counts: ${vm.counts}',
                          //         style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 16),
                          _buildStatsRow(vm),
                          const SizedBox(height: 12),
                          _buildFilterChips(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Bookings',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.indigo[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${bookings.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (bookings.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                                    const SizedBox(height: 12),
                                    Text(
                                      _filter == 'all' ? 'No bookings yet' : 'No $_filter bookings',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width Earnings Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Earnings',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${vm.totalEarnings.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Completed & Services Row
        Row(
          children: [
            Expanded(
              child: _miniStatCard(
                'Completed',
                vm.completedCount.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _miniStatCard(
                'Services',
                vm.totalServicesOffered.toString(),
                Icons.build,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Additional Stats Row
        Row(
          children: [
            Expanded(
              child: _miniStatCard(
                'Total Bookings',
                vm.bookings.length.toString(),
                Icons.bookmark,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _miniStatCard(
                'Pending',
                (vm.counts[BookingStatus.pending] ?? 0).toString(),
                Icons.schedule,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _miniStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = <String>['all'] + BookingStatus.values.map((e) => e.name).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Status',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: chips.map((c) {
              final selected = _filter == c;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(
                    c == 'all' ? 'All' : _prettyStatus(c),
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = c),
                  backgroundColor: Colors.grey[100],
                  selectedColor: _getStatusColor(c == 'all' ? BookingStatus.pending : BookingStatus.values.firstWhere((s) => s.name == c)).withOpacity(0.2),
                  side: BorderSide(
                    color: selected
                        ? _getStatusColor(c == 'all' ? BookingStatus.pending : BookingStatus.values.firstWhere((s) => s.name == c))
                        : Colors.grey[300]!,
                    width: selected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _prettyStatus(String name) {
    return name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim().capitalize();
  }

  Widget _buildBookingCard(BuildContext context, VendorHomePageProvider vm, BookingModel b) {
    final scheduled = b.scheduledDateTime.toLocal();
    final scheduledText = '${scheduled.day}/${scheduled.month}/${scheduled.year} ${scheduled.hour.toString().padLeft(2, '0')}:${scheduled.minute.toString().padLeft(2, '0')}';
    
    final statusColor = _getStatusColor(b.status);
    final statusBgColor = _getStatusBgColor(b.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.serviceDetails.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${b.id.substring(0, 8)}...',
                        style: const TextStyle(fontSize: 10, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    b.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Service Details
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    b.serviceDetails.address,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Customer & Schedule
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Customer: ${b.customerContact.name}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    scheduledText,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Pricing
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.green[600]),
                const SizedBox(width: 6),
                Text(
                  '₹${b.pricing.finalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
                const Spacer(),
                if (b.isPaymentCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Paid',
                      style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Unpaid',
                      style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _actionButtonsForStatus(context, vm, b),
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.blue;
      case BookingStatus.confirmed:
        return Colors.purple;
      case BookingStatus.inProgress:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return Colors.red;
    }
  }

  Color _getStatusBgColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.blue[100]!;
      case BookingStatus.confirmed:
        return Colors.purple[100]!;
      case BookingStatus.inProgress:
        return Colors.orange[100]!;
      case BookingStatus.completed:
        return Colors.green[100]!;
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return Colors.red[100]!;
    }
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