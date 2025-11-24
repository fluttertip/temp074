import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/personal_details_provider.dart';

class PersonalDetailsSection extends StatelessWidget {
  const PersonalDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonalDetailsProvider(),
      child: const _PersonalDetailsBody(),
    );
  }
}

class _PersonalDetailsBody extends StatelessWidget {
  const _PersonalDetailsBody();

  @override
  Widget build(BuildContext context) {
    return Consumer2<VendorProfileProvider, PersonalDetailsProvider>(
      builder: (context, vendorProvider, personalProvider, _) {
        final user = vendorProvider.user;

        // Initialize controllers
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!personalProvider.isInitialized && user != null) {
            personalProvider.initializeControllers(
              name: user.name,
              aboutMe: user.aboutMe ?? '',
              address: user.address ?? '',
            );
          }
        });

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.blue.shade600.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Update your basic information',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Fields
                _buildTextField(
                  controller: personalProvider.nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  hint: 'Enter your full name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: personalProvider.addressController,
                  label: 'Address',
                  icon: Icons.location_on_outlined,
                  hint: 'Enter your address',
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: personalProvider.aboutMeController,
                  label: 'About Me',
                  icon: Icons.info_outline,
                  hint:
                      'Tell customers about your experience, specialization, and what makes you unique...',
                  maxLines: null,
                  minLines: 4,
                ),
                const SizedBox(height: 20),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: personalProvider.isLoading
                        ? null
                        : () => _updatePersonalDetails(
                            context,
                            personalProvider,
                            vendorProvider,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: personalProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Update Personal Details',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int? maxLines = 1,
    int? minLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Future<void> _updatePersonalDetails(
    BuildContext context,
    PersonalDetailsProvider personalProvider,
    VendorProfileProvider vendorProvider,
  ) async {
    if (!personalProvider.validateForm()) {
      _showSnackBar(context, 'Please enter your name', isError: true);
      return;
    }

    personalProvider.setLoading(true);

    try {
      await vendorProvider.updateVendorPersonalDetails(
        name: personalProvider.nameController.text.trim(),
        aboutMe: personalProvider.aboutMeController.text.trim(),
        address: personalProvider.addressController.text.trim(),
      );

      _showSnackBar(context, ' Personal details updated successfully!');
    } catch (e) {
      _showSnackBar(
        context,
        ' Failed to update personal details',
        isError: true,
      );
    } finally {
      personalProvider.setLoading(false);
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
