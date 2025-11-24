import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/vendor/vendorprofileprovider/vendor_profile_provider.dart';

class SkillsCertificationsSection extends StatefulWidget {
  const SkillsCertificationsSection({super.key});

  @override
  State<SkillsCertificationsSection> createState() =>
      _SkillsCertificationsSectionState();
}

class _SkillsCertificationsSectionState
    extends State<SkillsCertificationsSection> {
  final _skillController = TextEditingController();
  final _certController = TextEditingController();
  List<String> _skills = [];
  List<String> _certifications = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _skillController.dispose();
    _certController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorProfileProvider>(
      builder: (context, provider, _) {
        final user = provider.user;

        if (!_isInitialized && user != null) {
          _skills = List.from(user.skills ?? []);
          _certifications = List.from(user.certifications ?? []);
          _isInitialized = true;
        }

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
                        color: Colors.green.shade50.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.build_outlined,
                        color: Colors.green.shade600.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skills & Certifications',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Showcase your expertise and qualifications',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Skills Section
                _buildSection(
                  title: 'Skills',
                  items: _skills,
                  controller: _skillController,
                  icon: Icons.psychology_outlined,
                  color: Colors.green,
                  hint: 'Enter a skill (e.g., Plumbing, Electrical)',
                  onAdd: _addSkill,
                  onRemove: _removeSkill,
                ),

                const SizedBox(height: 24),

                // Certifications Section
                _buildSection(
                  title: 'Certifications',
                  items: _certifications,
                  controller: _certController,
                  icon: Icons.verified_outlined,
                  color: Colors.blue,
                  hint: 'Enter a certification',
                  onAdd: _addCertification,
                  onRemove: _removeCertification,
                ),

                const SizedBox(height: 20),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _updateSkillsAndCertifications(provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
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
                                'Update Skills & Certifications',
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

  Widget _buildSection({
    required String title,
    required List<String> items,
    required TextEditingController controller,
    required IconData icon,
    required MaterialColor color,
    required String hint,
    required VoidCallback onAdd,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Add Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: Icon(icon, color: Colors.grey.shade600),
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
                    borderSide: BorderSide(color: color.shade600, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: color.shade600,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add $title',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Items List
        if (items.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map((item) => _buildItemChip(item, color, onRemove))
                .toList(),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: color.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No ${title.toLowerCase()} added yet. Add some to showcase your expertise!',
                    style: TextStyle(color: color.shade700, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildItemChip(
    String item,
    MaterialColor color,
    Function(String) onRemove,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item,
            style: TextStyle(
              color: color.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onRemove(item),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color.shade700,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _addCertification() {
    final cert = _certController.text.trim();
    if (cert.isNotEmpty && !_certifications.contains(cert)) {
      setState(() {
        _certifications.add(cert);
        _certController.clear();
      });
    }
  }

  void _removeCertification(String cert) {
    setState(() {
      _certifications.remove(cert);
    });
  }

  Future<void> _updateSkillsAndCertifications(
    VendorProfileProvider provider,
  ) async {
    setState(() => _isLoading = true);

    try {
      await provider.updateSkillsAndCertifications(
        skills: _skills,
        certifications: _certifications,
      );
      _showSnackBar('Skills and certifications updated successfully!');
    } catch (e) {
      _showSnackBar(
        'Failed to update skills and certifications',
        isError: true,
      );
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
}
