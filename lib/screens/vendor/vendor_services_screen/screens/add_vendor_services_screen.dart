import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/add_service_form_provider.dart';
import 'package:homeservice/providers/vendor/vendorserviceprovider/vendor_services_provider.dart';
import 'package:provider/provider.dart';

class AddVendorServicesScreen extends StatelessWidget {
  const AddVendorServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddServiceFormProvider(),
      child: const _AddVendorServiceForm(),
    );
  }
}

class _AddVendorServiceForm extends StatefulWidget {
  const _AddVendorServiceForm();

  @override
  State<_AddVendorServiceForm> createState() => _AddVendorServiceFormState();
}

class _AddVendorServiceFormState extends State<_AddVendorServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  bool _showTitleDropdown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formProvider = Provider.of<AddServiceFormProvider>(
        context,
        listen: false,
      );
      formProvider.initializeForm();
    });

    _titleFocusNode.addListener(() {
      setState(() {
        _showTitleDropdown = _titleFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add New Service',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Consumer<AddServiceFormProvider>(
        builder: (context, formProvider, _) {
          if (formProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading service options...'),
                ],
              ),
            );
          }

          if (formProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: TextStyle(fontSize: 18, color: Colors.red[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formProvider.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => formProvider.initializeForm(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return GestureDetector(
            onTap: () {
              if (_showTitleDropdown) {
                _titleFocusNode.unfocus();
              }
            },
            child: _buildForm(formProvider),
          );
        },
      ),
    );
  }

  Widget _buildForm(AddServiceFormProvider formProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('1. Service Category', Icons.category),
            const SizedBox(height: 8),
            _buildCategoryDropdown(formProvider),
            const SizedBox(height: 24),

            if (formProvider.selectedCategoryId != null) ...[
              _buildSectionHeader('2. Service Subcategory', Icons.list),
              const SizedBox(height: 8),
              _buildSubcategoryDropdown(formProvider),
              const SizedBox(height: 24),
            ],

            if (formProvider.selectedSubcategoryName != null) ...[
              _buildSectionHeader('3. Service Title', Icons.title),
              const SizedBox(height: 8),
              _buildTitleFieldWithDropdown(formProvider),
              const SizedBox(height: 24),
            ],

            if (formProvider.selectedSubcategoryName != null) ...[
              _buildSectionHeader('4. Pricing', Icons.attach_money),
              const SizedBox(height: 8),
              if (formProvider.minPrice > 0 && formProvider.maxPrice > 0)
                _buildPriceRangeInfo(formProvider),
              const SizedBox(height: 8),
              _buildPriceField(formProvider),
              const SizedBox(height: 16),
              _buildPricingUnitField(formProvider),
              const SizedBox(height: 24),
            ],

            if (formProvider.selectedSubcategoryName != null) ...[
              _buildSectionHeader('5. Service Description', Icons.description),
              const SizedBox(height: 8),
              _buildDescriptionField(formProvider),
              const SizedBox(height: 32),
            ],

            if (formProvider.selectedSubcategoryName != null)
              _buildSaveButton(formProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(AddServiceFormProvider formProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Select a service category',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        initialValue: formProvider.selectedCategoryId,
        items: formProvider.allCategories.map((category) {
          return DropdownMenuItem<String>(
            value: category.id,
            child: Text(category.category),
          );
        }).toList(),
        onChanged: (categoryId) {
          if (categoryId != null) {
            formProvider.selectCategory(categoryId);
          }
        },
        validator: (value) {
          if (value == null) return 'Please select a category';
          return null;
        },
      ),
    );
  }

  Widget _buildSubcategoryDropdown(AddServiceFormProvider formProvider) {
    if (formProvider.isLoadingSubcategories) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Select a subcategory',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        initialValue: formProvider.selectedSubcategoryName,
        items: formProvider.availableSubcategories.map((subcategoryName) {
          return DropdownMenuItem<String>(
            value: subcategoryName,
            child: Text(subcategoryName),
          );
        }).toList(),
        onChanged: (subcategoryName) {
          if (subcategoryName != null) {
            formProvider.selectSubcategory(subcategoryName);
          }
        },
        validator: (value) {
          if (value == null) return 'Please select a subcategory';
          return null;
        },
      ),
    );
  }

  Widget _buildTitleFieldWithDropdown(AddServiceFormProvider formProvider) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: formProvider.titleController,
            focusNode: _titleFocusNode,
            decoration: InputDecoration(
              hintText: 'Select from available titles or enter your own',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (formProvider.isLoadingTitles)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    Icon(
                      _showTitleDropdown
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.grey[600],
                    ),
                ],
              ),
            ),
            onChanged: (value) {
              formProvider.filterTitles(value);
              formProvider.onFieldChanged();
            },
            onTap: () {
              if (formProvider.filteredTitles.isEmpty) {
                formProvider.filterTitles('');
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a service title';
              }
              return null;
            },
          ),
        ),

        if (_showTitleDropdown && formProvider.filteredTitles.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: formProvider.filteredTitles.length,
              itemBuilder: (context, index) {
                final title = formProvider.filteredTitles[index];
                return InkWell(
                  onTap: () {
                    formProvider.selectTitle(title);
                    _titleFocusNode.unfocus();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.title, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(title)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        if (_showTitleDropdown &&
            formProvider.filteredTitles.isEmpty &&
            !formProvider.isLoadingTitles &&
            formProvider.allTitles.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search_off, color: Colors.grey[600]),
                const SizedBox(width: 8),
                const Text(
                  'No titles match your search',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

        if (_showTitleDropdown &&
            formProvider.allTitles.isEmpty &&
            !formProvider.isLoadingTitles)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'No existing titles found. You can create a new title!',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRangeInfo(AddServiceFormProvider formProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Price range for this category: NPR ${formProvider.minPrice.toStringAsFixed(0)} - NPR ${formProvider.maxPrice.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField(AddServiceFormProvider formProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: formProvider.priceController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: const InputDecoration(
          hintText: 'Enter your price',
          prefixText: 'NPR ',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        onChanged: (_) => formProvider.onFieldChanged(),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a price';
          }
          final price = double.tryParse(value);
          if (price == null || price <= 0) {
            return 'Please enter a valid price';
          }
          if (formProvider.minPrice > 0 && formProvider.maxPrice > 0) {
            if (price < formProvider.minPrice ||
                price > formProvider.maxPrice) {
              return 'Price must be between ${formProvider.minPrice.toStringAsFixed(0)} and ${formProvider.maxPrice.toStringAsFixed(0)}';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPricingUnitField(AddServiceFormProvider formProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: 'Select pricing unit',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        initialValue: formProvider.selectedPricingUnit,
        items: formProvider.pricingUnits.map((unit) {
          return DropdownMenuItem<String>(value: unit, child: Text(unit));
        }).toList(),
        onChanged: (unit) {
          if (unit != null) {
            formProvider.selectPricingUnit(unit);
          }
        },
        validator: (value) {
          if (value == null) return 'Please select a pricing unit';
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField(AddServiceFormProvider formProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: formProvider.descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Enter service description',
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
        ),
        onChanged: (_) => formProvider.onFieldChanged(),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a description';
          }
          if (value.trim().length < 10) {
            return 'Description must be at least 10 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton(AddServiceFormProvider formProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: formProvider.isValid ? () => _saveService() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: const Text(
          'Save Service',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    final formProvider = Provider.of<AddServiceFormProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final servicesProvider = Provider.of<VendorServicesProvider>(
      context,
      listen: false,
    );

    final validationError = formProvider.validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError), backgroundColor: Colors.red),
      );
      return;
    }

    if (userProvider.getCachedUser()?.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final serviceModel = formProvider.createServiceModel(
        userProvider.getCachedUser()!.uid,
      );
      await servicesProvider.addService(serviceModel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add service: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
