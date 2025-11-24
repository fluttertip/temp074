import 'package:flutter/material.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/navigation/role_navigation_provider.dart';
import 'package:provider/provider.dart';

class CommonRoleSwitcherWidget extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? cardElevation;
  final Color? headerIconColor;
  final TextStyle? headerTextStyle;
  final TextStyle? currentRoleTextStyle;
  final BorderRadius? cardBorderRadius;
  final bool showHeader;
  final bool shrinkWrap;
  final VoidCallback? onRoleChanged;

  const CommonRoleSwitcherWidget({
    super.key,
    this.padding,
    this.cardElevation,
    this.headerIconColor,
    this.headerTextStyle,
    this.currentRoleTextStyle,
    this.cardBorderRadius,
    this.showHeader = true,
    this.shrinkWrap = true,
    this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: padding ?? const EdgeInsets.all(8),
          child: Card(
            elevation: cardElevation ?? 2,
            shape: RoundedRectangleBorder(
              borderRadius: cardBorderRadius ?? BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) ...[
                    _buildHeader(userProvider),
                    const SizedBox(height: 16),
                  ],
                  _buildRolesList(context, userProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.swap_horiz,
              color: headerIconColor ??
                  _getThemeColorForRole(userProvider.activeRole ?? 'customer'),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Account Type',
              style: headerTextStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Current: ${(userProvider.activeRole ?? 'CUSTOMER').toUpperCase()}',
          style: currentRoleTextStyle ??
              TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRolesList(BuildContext context, UserProvider userProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRoleCard(
          context,
          userProvider.activeRole!,
          isActive: true,
          isLoading: false,
          onTap: null,
        ),
        const SizedBox(height: 12),
        ...userProvider.availableRoles
            .where((role) => role != userProvider.activeRole)
            .map(
              (role) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRoleCard(
                  context,
                  role,
                  isActive: false,
                  isLoading: userProvider.isRoleSwitching,
                  onTap: userProvider.isRoleSwitching
                      ? null
                      : () => _switchRole(context, userProvider, role),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String role, {
    required bool isActive,
    required bool isLoading,
    VoidCallback? onTap,
  }) {
    final themeColor = _getThemeColorForRole(role);

    return Card(
      elevation: isActive ? 3 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? themeColor.withOpacity(0.2)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconForRole(role),
            color: isActive ? themeColor : Colors.grey.shade600,
            size: 24,
          ),
        ),
        title: Text(
          '${_formatRoleName(role)} Mode',
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? themeColor : Colors.black87,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          isActive
              ? 'Currently Active'
              : isLoading
                  ? 'Switching...'
                  : 'Tap to switch',
          style: TextStyle(
            color: isActive
                ? themeColor.withOpacity(0.7)
                : Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        trailing: _buildTrailingWidget(isActive, isLoading, themeColor),
        onTap: isLoading ? null : onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTrailingWidget(bool isActive, bool isLoading, Color themeColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      );
    }

    if (isActive) {
      return Icon(Icons.check_circle, color: themeColor, size: 24);
    }

    return Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16);
  }

  IconData _getIconForRole(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return Icons.person;
      case 'vendor':
        return Icons.work;
      default:
        return Icons.account_circle;
    }
  }

  Color _getThemeColorForRole(String role) {
    switch (role.toLowerCase()) {
      case 'customer':
        return Colors.blue;
      case 'vendor':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatRoleName(String role) {
    return role.substring(0, 1).toUpperCase() + role.substring(1).toLowerCase();
  }

  Future<void> _switchRole(
    BuildContext context,
    UserProvider userProvider,
    String newRole,
  ) async {
    // Get the navigation provider BEFORE showing dialog
    final navigationProvider = Provider.of<RoleNavigationProvider>(
      context,
      listen: false,
    );

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getThemeColorForRole(newRole),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Switching to ${_formatRoleName(newRole)} mode...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Perform the role switch
      final success = await userProvider.switchActiveRole(newRole);

      // Close the loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        print('✓ Role switched successfully to $newRole');

        // CRITICAL: Reset navigation to the first tab (index 0)
        navigationProvider.resetIndex();

        // Optional: Call the callback if provided
        onRoleChanged?.call();

        // Force navigation refresh by navigating away and back
        // Use a microtask to ensure the dialog is closed first
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/unified-home');
          }
        });
      } else {
        print('✗ Failed to switch role to $newRole');

        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to switch role. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('✗ Role switch error: $e');

      // Ensure dialog is closed on error
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
