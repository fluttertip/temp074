import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';

class KycVerificationSection extends StatefulWidget {
  const KycVerificationSection({super.key});

  @override
  State<KycVerificationSection> createState() => _KycVerificationSectionState();
}

class _KycVerificationSectionState extends State<KycVerificationSection> {
  final _fullNameCtrl = TextEditingController();
  final _citizenshipNumberCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _issueDateCtrl = TextEditingController();
  final _issuingAuthorityCtrl = TextEditingController();
  bool _isLoading = false;

  // Image picker for kyc
  final ImagePicker _picker = ImagePicker();
  File? _citizenshipFrontImage;
  File? _citizenshipBackImage;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _citizenshipNumberCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _issueDateCtrl.dispose();
    _issuingAuthorityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorProfileProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final kycStatus = user?.kycStatus ?? 'unverified';
        final kycData = user?.kyc;

        // existing data loading with editable for rejected and non editable for others
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (kycData != null && kycData.isNotEmpty) {
            _fullNameCtrl.text = kycData['fullName']?.toString() ?? '';
            _citizenshipNumberCtrl.text =
                kycData['citizenshipNumber']?.toString() ?? '';
            _dobCtrl.text = kycData['dateOfBirth']?.toString() ?? '';
            _addressCtrl.text = kycData['address']?.toString() ?? '';
            _issueDateCtrl.text = kycData['issueDate']?.toString() ?? '';
            _issuingAuthorityCtrl.text =
                kycData['issuingAuthority']?.toString() ?? '';
          }
        });

        final bool isEditable =
            kycStatus == 'unverified' || kycStatus == 'rejected';
        final bool showFaded =
            kycStatus == 'pending' || kycStatus == 'approved';

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
                // Section Header with Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(kycStatus).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getStatusIcon(kycStatus),
                        color: _getStatusColor(kycStatus).withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KYC Verification',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _getStatusDescription(kycStatus),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(kycStatus),
                  ],
                ),

                const SizedBox(height: 16),

                _buildStatusMessage(kycStatus),

                const SizedBox(height: 16),

                Opacity(
                  opacity: showFaded ? 0.6 : 1.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildKycTextField(
                              controller: _fullNameCtrl,
                              label: 'Full Name',
                              hint: 'As per citizenship',
                              icon: Icons.person_outline,
                              enabled: isEditable,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildKycTextField(
                              controller: _citizenshipNumberCtrl,
                              label: 'Citizenship Number',
                              hint: 'Enter number',
                              icon: Icons.credit_card,
                              enabled: isEditable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildKycTextField(
                              controller: _dobCtrl,
                              label: 'Date of Birth',
                              hint: 'YYYY MM DD',
                              icon: Icons.calendar_today,
                              enabled: isEditable,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildKycTextField(
                              controller: _issueDateCtrl,
                              label: 'Issue Date',
                              hint: 'YYYY MM DD',
                              icon: Icons.date_range,
                              enabled: isEditable,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildKycTextField(
                        controller: _addressCtrl,
                        label: 'Address',
                        hint: 'As per citizenship certificate',
                        icon: Icons.location_on_outlined,
                        enabled: isEditable,
                      ),
                      const SizedBox(height: 16),
                      _buildKycTextField(
                        controller: _issuingAuthorityCtrl,
                        label: 'Issuing Authority',
                        hint: 'e.g., District Administration Office',
                        icon: Icons.account_balance,
                        enabled: isEditable,
                      ),

                      const SizedBox(height: 24),

                      _buildDocumentUploadSection(isEditable),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Submit Button
                if (isEditable)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitKyc(provider, kycStatus),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kycStatus == 'rejected'
                            ? Colors.orange.shade600.withOpacity(0.9)
                            : Colors.teal.shade600.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  kycStatus == 'rejected'
                                      ? Icons.refresh
                                      : Icons.upload_outlined,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  kycStatus == 'rejected'
                                      ? 'Resubmit KYC Verification'
                                      : 'Submit KYC Verification',
                                  style: const TextStyle(
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

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            _getStatusText(status),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(String status) {
    Color backgroundColor;
    Color iconColor;
    Color textColor;
    String message;
    IconData icon;

    switch (status) {
      case 'approved':
        backgroundColor = Colors.green.shade50;
        iconColor = Colors.green.shade600;
        textColor = Colors.green.shade700;
        message =
            ' Congratulations! Your KYC has been verified successfully. You can now receive bookings from customers.';
        icon = Icons.verified;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade50;
        iconColor = Colors.orange.shade600;
        textColor = Colors.orange.shade700;
        message =
            '⏳ Your KYC submission is under review. We\'ll notify you once it\'s processed (usually within 24-48 hours).';
        icon = Icons.hourglass_empty;
        break;
      case 'rejected':
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.red.shade600;
        textColor = Colors.red.shade700;
        message =
            ' Your KYC verification was rejected. Please review the information below and resubmit with correct details.';
        icon = Icons.error;
        break;
      default:
        backgroundColor = Colors.blue.shade50;
        iconColor = Colors.blue.shade600;
        textColor = Colors.blue.shade700;
        message =
            'Complete your KYC verification to build trust with customers and receive more bookings. This process helps verify your identity.';
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKycTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool enabled,
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
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.verified;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Verified';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unverified';
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'approved':
        return 'Your identity has been verified';
      case 'pending':
        return 'Verification in progress';
      case 'rejected':
        return 'Verification failed - resubmit required';
      default:
        return 'Verify your identity to build trust';
    }
  }

  bool _validateForm() {
    return _fullNameCtrl.text.trim().isNotEmpty &&
        _citizenshipNumberCtrl.text.trim().isNotEmpty &&
        _dobCtrl.text.trim().isNotEmpty &&
        _addressCtrl.text.trim().isNotEmpty &&
        _issueDateCtrl.text.trim().isNotEmpty &&
        _issuingAuthorityCtrl.text.trim().isNotEmpty;
  }

  Future<void> _submitKyc(
    VendorProfileProvider provider,
    String currentStatus,
  ) async {
    if (!_validateForm()) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final details = {
        'fullName': _fullNameCtrl.text.trim(),
        'citizenshipNumber': _citizenshipNumberCtrl.text.trim(),
        'dateOfBirth': _dobCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'issueDate': _issueDateCtrl.text.trim(),
        'issuingAuthority': _issuingAuthorityCtrl.text.trim(),
      };

      await provider.submitKycDetails(details);

      _showSnackBar(
        currentStatus == 'rejected'
            ? ' KYC resubmitted successfully! Please wait for approval.'
            : ' KYC submitted successfully! Please wait for approval.',
      );
    } catch (e) {
      _showSnackBar(' Failed to submit KYC: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
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

  Widget _buildDocumentUploadSection(bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(Icons.upload_file, color: Colors.indigo.shade600, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Citizenship Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload clear photos of both sides of your citizenship certificate',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            // Front Side Upload
            Expanded(
              child: _buildDocumentCard(
                title: 'Front Side',
                image: _citizenshipFrontImage,
                onTap: isEditable ? () => _pickCitizenshipImage(true) : null,
              ),
            ),
            const SizedBox(width: 12),
            // Back Side Upload
            Expanded(
              child: _buildDocumentCard(
                title: 'Back Side',
                image: _citizenshipBackImage,
                onTap: isEditable ? () => _pickCitizenshipImage(false) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required File? image,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: image != null ? Colors.green.shade300 : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: image != null ? Colors.green.shade50 : Colors.grey.shade50,
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.file(
                      image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (onTap != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: onTap,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            padding: const EdgeInsets.all(4),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 32,
                    color: onTap != null
                        ? Colors.indigo.shade400
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: onTap != null
                          ? Colors.indigo.shade600
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tap to upload',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Future<void> _pickCitizenshipImage(bool isFront) async {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Upload ${isFront ? 'Front' : 'Back'} Side',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.camera, color: Colors.blue.shade600),
                  ),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Use camera to capture document'),
                  onTap: () {
                    Navigator.pop(context);
                    _captureImage(ImageSource.camera, isFront);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: Colors.green.shade600,
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select existing photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _captureImage(ImageSource.gallery, isFront);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar('Failed to open image options: $e', isError: true);
    }
  }

  Future<void> _captureImage(ImageSource source, bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (isFront) {
            _citizenshipFrontImage = File(image.path);
          } else {
            _citizenshipBackImage = File(image.path);
          }
        });

        _showSnackBar(
          '${isFront ? 'Front' : 'Back'} side document added! (Temporary - will save to Firebase when implemented)',
        );
      }
    } catch (e) {
      _showSnackBar('Failed to capture image: $e', isError: true);
    }
  }
}
