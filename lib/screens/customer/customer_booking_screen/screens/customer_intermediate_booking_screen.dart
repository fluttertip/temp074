import 'package:flutter/material.dart';
import 'package:homeservice/providers/customer/customerbookingprovider/customer_booking_provider.dart';
import 'package:homeservice/providers/location/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:intl/intl.dart';

class IntermediateBookingScreen extends StatefulWidget {
  const IntermediateBookingScreen({super.key});

  @override
  State<IntermediateBookingScreen> createState() =>
      _IntermediateBookingScreenState();
}

class _IntermediateBookingScreenState extends State<IntermediateBookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _useCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    // Load current location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      locationProvider.getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _confirmBooking(
    ServiceModel service,
    UserModel vendor,
    UserProvider userProvider,
    LocationProvider locationProvider,
    CustomerBookingProvider bookingProvider,
  ) async {
    // Validation
    if (_selectedDate == null) {
      _showSnackBar('Please select a date', isError: true);
      return;
    }

    if (_selectedTime == null) {
      _showSnackBar('Please select a time', isError: true);
      return;
    }

    final currentUser = userProvider.getCachedUser();
    if (currentUser == null) {
      _showSnackBar('User not found. Please sign in again.', isError: true);
      return;
    }

    String location;
    double? latitude;
    double? longitude;
    
    if (_useCurrentLocation) {
      // Check if location service is enabled
      if (!locationProvider.locationServiceEnabled) {
        final openSettings = await _showLocationServiceDialog();
        if (openSettings) {
          await locationProvider.openLocationSettings();
          await Future.delayed(const Duration(seconds: 1));
          await locationProvider.refreshLocation();
        }
        return;
      }

      // Check if permission is granted
      if (!locationProvider.hasPermission) {
        final shouldRequest = await _showPermissionDialog();
        if (shouldRequest) {
          final granted = await locationProvider.requestPermission();
          if (granted) {
            await locationProvider.refreshLocation();
          } else {
            _showSnackBar('Location permission is required for booking', isError: true);
            return;
          }
        } else {
          return;
        }
      }

      // Validate location data
      if (!locationProvider.isLocationValid()) {
        _showSnackBar('Unable to get location. Please try again or enter manually.', isError: true);
        return;
      }

      location = locationProvider.currentLocation;
      latitude = locationProvider.latitude;
      longitude = locationProvider.longitude;

      // Final validation
      if (latitude == null || longitude == null) {
        _showSnackBar('Could not get precise location. Please enter manually.', isError: true);
        setState(() {
          _useCurrentLocation = false;
        });
        return;
      }
    } else {
      location = _locationController.text.trim();
      if (location.isEmpty) {
        _showSnackBar('Please enter a location', isError: true);
        return;
      }
      latitude = null;
      longitude = null;
    }

    // Show warning if no coordinates available
    if (latitude == null || longitude == null) {
      final proceed = await _showNoCoordinatesDialog();
      if (!proceed) return;
    }

    try {
      // Combine date and time
      final scheduledDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Create booking using provider (CLEAN!)
      final bookingId = await bookingProvider.createBooking(
        customer: currentUser,
        vendor: vendor,
        service: service,
        scheduledDateTime: scheduledDateTime,
        location: location,
        latitude: latitude,
        longitude: longitude,
        bookingNotes: _notesController.text.trim(),
      );

      if (bookingId != null && mounted) {
        print('✅ [Booking] Booking created successfully: $bookingId');
        
        Navigator.pushReplacementNamed(
          context,
          '/customer/booking/success',
          arguments: {
            'service': service,
            'scheduledDateTime': scheduledDateTime,
            'location': location,
          },
        );
      } else if (mounted) {
        _showSnackBar(
          bookingProvider.error ?? 'Failed to create booking',
          isError: true,
        );
      }
    } catch (e) {
      print('❌ [Booking] Failed to create booking: $e');
      if (mounted) {
        _showSnackBar('Failed to book service: $e', isError: true);
      }
    }
  }

  Future<bool> _showLocationServiceDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Location services are required for booking. Please enable location services in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'We need your location to provide accurate service delivery. The vendor will use this location to reach you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showNoCoordinatesDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: const Text(
          'Without precise GPS coordinates, the vendor may have difficulty finding your exact location. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Continue Anyway'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Invalid booking data'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final service = args['service'] as ServiceModel;
    final vendor = args['vendor'] as UserModel;

    return Consumer3<UserProvider, LocationProvider, CustomerBookingProvider>(
      builder: (context, userProvider, locationProvider, bookingProvider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Confirm Booking'),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceSummaryCard(service, vendor),
                const SizedBox(height: 24),
                _buildScheduleSection(),
                const SizedBox(height: 24),
                _buildLocationSection(locationProvider),
                const SizedBox(height: 24),
                _buildNotesSection(),
                const SizedBox(height: 24),
                _buildPriceSummary(service),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBottomButton(
              service,
              vendor,
              userProvider,
              locationProvider,
              CustomerBookingProvider(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceSummaryCard(ServiceModel service, UserModel vendor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              service.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${vendor.name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDateSelector()),
            const SizedBox(width: 12),
            Expanded(child: _buildTimeSelector()),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(LocationProvider locationProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Precise location is required for the vendor to reach you',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        _buildLocationToggle(),
        const SizedBox(height: 12),
        if (_useCurrentLocation)
          _buildCurrentLocationDisplay(locationProvider)
        else
          _buildManualLocationInput(),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes (Optional)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requirements or instructions...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                style: TextStyle(
                  fontSize: 14,
                  color: _selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 20, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedTime == null
                    ? 'Select Time'
                    : _selectedTime!.format(context),
                style: TextStyle(
                  fontSize: 14,
                  color: _selectedTime == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationToggle() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: _useCurrentLocation,
            onChanged: (value) => setState(() => _useCurrentLocation = value!),
            title: const Text('Current Location (GPS)'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            value: false,
            groupValue: _useCurrentLocation,
            onChanged: (value) => setState(() => _useCurrentLocation = value!),
            title: const Text('Manual Entry'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationDisplay(LocationProvider locationProvider) {
    Color backgroundColor;
    Color borderColor;
    Color iconColor;
    IconData icon;

    if (locationProvider.isLoading) {
      backgroundColor = Colors.grey.shade50;
      borderColor = Colors.grey.shade200;
      iconColor = Colors.grey;
      icon = Icons.location_searching;
    } else if (!locationProvider.locationServiceEnabled) {
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red.shade200;
      iconColor = Colors.red;
      icon = Icons.location_disabled;
    } else if (!locationProvider.hasPermission) {
      backgroundColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade200;
      iconColor = Colors.orange;
      icon = Icons.location_off;
    } else if (locationProvider.latitude != null && locationProvider.longitude != null) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
      iconColor = Colors.green;
      icon = Icons.check_circle;
    } else {
      backgroundColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade200;
      iconColor = Colors.blue;
      icon = Icons.location_on;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  locationProvider.isLoading
                      ? 'Getting your location...'
                      : locationProvider.currentLocation,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (!locationProvider.isLoading)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => locationProvider.refreshLocation(),
                  tooltip: 'Refresh location',
                ),
            ],
          ),
          if (locationProvider.latitude != null && locationProvider.longitude != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 36),
              child: Text(
                'GPS: ${locationProvider.latitude!.toStringAsFixed(6)}, ${locationProvider.longitude!.toStringAsFixed(6)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildManualLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: 'Enter detailed address (e.g., Thamel, Near ABC Hotel)',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber, size: 20, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Be as specific as possible - the vendor will use this to find you',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(ServiceModel service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Service Price'),
              Text('Rs. ${service.price}'),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs. ${service.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(
    ServiceModel service,
    UserModel vendor,
    UserProvider userProvider,
    LocationProvider locationProvider,
    CustomerBookingProvider bookingProvider,
  ) {
    final isLoading = bookingProvider.isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () => _confirmBooking(
                  service,
                  vendor,
                  userProvider,
                  locationProvider,
                  bookingProvider,
                ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}