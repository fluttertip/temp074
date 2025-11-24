import 'package:flutter/material.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/vendor_services_provider.dart';
import 'package:homeservice/routes/app_routes.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:homeservice/screens/vendor/vendor_services_screen/widgets/service_tile_widget.dart';
import 'package:provider/provider.dart';

class VendorServicesScreen extends StatefulWidget {
  const VendorServicesScreen({super.key});

  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final serviceProvider = Provider.of<VendorServicesProvider>(
      context,
      listen: false,
    );

    if (userProvider.getCachedUser()?.uid != null) {
      serviceProvider.fetchProviderServices(userProvider.getCachedUser()!.uid);
      serviceProvider.fetchHardcodedServicesInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Consumer<VendorProfileProvider>(
              builder: (context, provider, _) {
                if (!provider.isVendorProfileComplete &&
                    !provider.isBannerShown('vendor_services')) {
                  provider.markBannerShown('vendor_services');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    CompleteProfileBannerOverlay.show(
                      context,
                      message:
                          "Complete your vendor profile to unlock all features",
                      duration: const Duration(seconds: 5),
                    );
                  });
                }
                return const SizedBox.shrink();
              },
            ),

            _buildHeader(),

            Expanded(
              child: Consumer<VendorServicesProvider>(
                builder: (context, serviceProvider, _) {
                  if (serviceProvider.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading your services...'),
                        ],
                      ),
                    );
                  }

                  if (serviceProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading services',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            serviceProvider.error ?? 'Unknown error',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _initializeData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (serviceProvider.services.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildServicesList(serviceProvider.services);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('username later implement',
                // 'Welcome back, ${userProvider.getCachedUser()DisplayName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your services and grow your business',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_center_outlined,
                size: 64,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No services added yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start building your business by adding your first service. Customers are waiting for what you offer!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToAddService,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    return RefreshIndicator(
      onRefresh: () async {
        _initializeData();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceTileWidget(
              service: service,
              onEdit: () => _navigateToEditService(service),
              onDelete: () => _showDeleteConfirmation(service),
              onToggleStatus: () => _toggleServiceStatus(service),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<VendorProfileProvider>(
      builder: (context, vendorProvider, _) {
        return FloatingActionButton.extended(
          onPressed: () {
            if (!vendorProvider.isVendorProfileComplete) {
              CompleteProfileBannerOverlay.show(
                context,
                message: "Complete your vendor profile to unlock all features",
                duration: const Duration(seconds: 5),
              );
              return;
            }
            _navigateToAddService();
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Service'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        );
      },
    );
  }

  void _navigateToAddService() async {
    final serviceProvider = Provider.of<VendorServicesProvider>(
      context,
      listen: false,
    );

    serviceProvider.clearSubcategories();

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addVendorService,
    );

    if (result == true) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.getCachedUser()?.uid != null) {
        serviceProvider.fetchProviderServices(userProvider.getCachedUser()!.uid);
      }
    }
  }

  void _navigateToEditService(ServiceModel service) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editVendorService,
      arguments: service,
    );

    if (result == true) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final serviceProvider = Provider.of<VendorServicesProvider>(
        context,
        listen: false,
      );

      if (userProvider.getCachedUser()?.uid != null) {
        serviceProvider.fetchProviderServices(userProvider.getCachedUser()!.uid);
      }
    }
  }

  void _toggleServiceStatus(ServiceModel service) {
    final serviceProvider = Provider.of<VendorServicesProvider>(
      context,
      listen: false,
    );

    final updatedService = ServiceModel(
      id: service.id,
      providerId: service.providerId,
      category: service.category,
      title: service.title,
      imageUrl: service.imageUrl,
      price: service.price,
      rating: service.rating,
      description: service.description,
      isActive: !service.isActive,
      admindelete: service.admindelete,
      adminapprove: service.adminapprove,
      createdAt: service.createdAt,
    );

    serviceProvider
        .updateService(updatedService)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                updatedService.isActive
                    ? 'Service activated successfully!'
                    : 'Service deactivated successfully!',
              ),
              backgroundColor: updatedService.isActive
                  ? Colors.green
                  : Colors.orange,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update service: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  void _showDeleteConfirmation(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text(
            "Are you sure you want to delete '${service.title}'? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteService(service);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(ServiceModel service) {
    final serviceProvider = Provider.of<VendorServicesProvider>(
      context,
      listen: false,
    );

    serviceProvider
        .deleteService(service.id)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete service: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
