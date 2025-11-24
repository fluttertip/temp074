import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/customer/customerprofileprovider/customer_profile_provider.dart';

class ProfileInfoSection extends StatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final customerprofileprovider = Provider.of<CustomerProfileProvider>(
      context,
      listen: false,
    );

    _nameController = TextEditingController();
    _addressController = TextEditingController();

    if (customerprofileprovider.user != null) {
      _nameController.text = customerprofileprovider.user!.name;
      _addressController.text = customerprofileprovider.user!.address ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        customerprofileprovider.updateEditingName(_nameController.text);
        customerprofileprovider.updateEditingAddress(_addressController.text);
      });
    }

    _nameController.addListener(() {
      customerprofileprovider.updateEditingName(_nameController.text);
    });
    _addressController.addListener(() {
      customerprofileprovider.updateEditingAddress(_addressController.text);
    });
  }

  @override
  void didUpdateWidget(covariant ProfileInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider = Provider.of<CustomerProfileProvider>(
      context,
      listen: false,
    );
    if (provider.user != null) {
      _nameController.text = provider.user!.name;
      _addressController.text = provider.user!.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<CustomerProfileProvider>(
        builder: (context, customerprofileprovider, _) {
          final user = customerprofileprovider.user;
          if (user == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: TextEditingController(
                    // text: user.phoneNumber ?? '',
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: customerprofileprovider.isUpdating
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();

                            final success = await customerprofileprovider
                                .updateCustomerPersonalDetails();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Profile updated successfully'
                                        : customerprofileprovider.error ??
                                              'Failed to update profile',
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }
                          },
                    child: customerprofileprovider.isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            customerprofileprovider.isCustomerProfileComplete
                                ? 'Update Personal Details'
                                : 'Complete Profile',
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
