import 'package:flutter/material.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';
import '../components/cover_profile_header.dart';
import '../components/personal_details_section.dart';
import '../components/service_areas_section.dart';
import '../components/skills_certifications_section.dart';
import '../components/kyc_verification_section.dart';
import '../components/notification_settings_section.dart';

class VenodrProfileScreen extends StatelessWidget {
  const VenodrProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VendorProfileBody();
  }
}

class _VendorProfileBody extends StatefulWidget {
  const _VendorProfileBody();

  @override
  State<_VendorProfileBody> createState() => _VendorProfileBodyState();
}

class _VendorProfileBodyState extends State<_VendorProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VendorProfileProvider>(
      builder: (context, provider, _) {
        if (!provider.isVendorProfileComplete &&
            !provider.isBannerShown('vendor_profile')) {
          provider.markBannerShown('vendor_profile');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CompleteProfileBannerOverlay.show(
              context,
              message: "Update profile and submit Kyc to unlock all features",
              duration: const Duration(seconds: 5),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: CoverProfileHeader()),

                      if (provider.error != null)
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.red.shade200.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade600.withOpacity(0.8),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    provider.error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700.withOpacity(
                                        0.9,
                                      ),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              KycVerificationSection(),
                              SizedBox(height: 16),
                              PersonalDetailsSection(),
                              SizedBox(height: 16),
                              ServiceAreasSection(),
                              SizedBox(height: 16),
                              SkillsCertificationsSection(),
                              SizedBox(height: 16),
                              NotificationSettingsSection(),
                              SizedBox(height: 32),
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
}
