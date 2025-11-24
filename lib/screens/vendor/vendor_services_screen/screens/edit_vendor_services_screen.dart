import 'package:flutter/material.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/edit_service_form_provider.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/vendor_services_provider.dart';
import 'package:provider/provider.dart';

class EditVendorServicesScreen extends StatelessWidget {
  final ServiceModel service;

  const EditVendorServicesScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditServiceFormProvider.fromService(service),
      child: _EditVendorServiceFormBody(service: service),
    );
  }
}

class _EditVendorServiceFormBody extends StatefulWidget {
  final ServiceModel service;
  const _EditVendorServiceFormBody({required this.service});

  @override
  State<_EditVendorServiceFormBody> createState() =>
      _EditVendorServiceFormBodyState();
}

class _EditVendorServiceFormBodyState
    extends State<_EditVendorServiceFormBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceProvider = Provider.of<VendorServicesProvider>(
        context,
        listen: false,
      );
      final formProvider = Provider.of<EditServiceFormProvider>(
        context,
        listen: false,
      );

      if (formProvider.selectedCategory != null) {
        serviceProvider.fetchSubcategoriesByCategory(
          formProvider.selectedCategory!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<VendorServicesProvider>(context);
    final formProvider = Provider.of<EditServiceFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Service'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit, color: Colors.orange.shade600, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        'Edit Service Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update your service details to better serve your customers.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Service Category'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: formProvider.selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.category,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  items: serviceProvider.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    formProvider.setCategory(val);
                    if (val != null) {
                      serviceProvider.fetchSubcategoriesByCategory(val);
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a category'
                      : null,
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('Service Title'),
                const SizedBox(height: 8),
                CompositedTransformTarget(
                  link: formProvider.layerLink,
                  child: TextFormField(
                    controller: formProvider.titleController,
                    decoration: InputDecoration(
                      labelText: "Service Title *",
                      hintText: "Enter or select from suggestions",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(
                        Icons.build,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    onChanged: (_) {
                      formProvider.showSuggestions(
                        context,
                        serviceProvider.subcategories,
                      );
                      formProvider.onFieldChanged();
                    },
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter service title'
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                if (formProvider.selectedSubcategory != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Selected Service',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formProvider.selectedSubcategory!.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formProvider.selectedSubcategory!.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                _buildSectionTitle('Pricing'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: formProvider.priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price (NPR) *",
                    hintText: "Enter your service price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.blue.shade600,
                    ),
                    prefixText: "NPR ",
                  ),
                  onChanged: (_) => formProvider.onFieldChanged(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter price';
                    }
                    final price = double.tryParse(value.trim());
                    if (price == null || price <= 0) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('Service Description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: formProvider.descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description *",
                    hintText: "Describe your service in detail...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.description,
                      color: Colors.blue.shade600,
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  onChanged: (_) => formProvider.onFieldChanged(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter description';
                    }
                    if (value.trim().length < 20) {
                      return 'Description should be at least 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: formProvider.isValid && !formProvider.isLoading
                        ? () => _updateService(formProvider, serviceProvider)
                        : null,
                    icon: formProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      formProvider.isLoading ? 'Updating...' : 'Update Service',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Future<void> _updateService(
    EditServiceFormProvider formProvider,
    VendorServicesProvider serviceProvider,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    formProvider.setLoading(true);

    try {
      final updatedService = ServiceModel(
        id: formProvider.serviceId,
        providerId: widget.service.providerId,
        category: formProvider.selectedCategory!,
        title: formProvider.titleController.text.trim(),
        imageUrl: formProvider.selectedImage,
        price: double.parse(formProvider.priceController.text.trim()),
        description: formProvider.descriptionController.text.trim(),
        isActive: widget.service.isActive,
        admindelete: widget.service.admindelete,
        adminapprove: widget.service.adminapprove,
        createdAt: widget.service.createdAt,
        rating: widget.service.rating,
      );

      await serviceProvider.updateService(updatedService);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update service: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        formProvider.setLoading(false);
      }
    }
  }
}
