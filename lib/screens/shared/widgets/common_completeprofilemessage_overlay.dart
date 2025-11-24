import 'package:flutter/material.dart';

class CompleteProfileBannerOverlay {
  static OverlayEntry? _currentOverlay;
  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? top,
    double? bottom,
    double left = 16,
    double right = 16,
  }) {
    // Remove any existing overlay first
    hide();

    _isShowing = true;
    late AnimationController controller;
    late Animation<Offset> slideAnimation;
    late Animation<double> fadeAnimation;

    controller = AnimationController(
      vsync: Overlay.of(context),
      duration: const Duration(milliseconds: 300),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: top ?? (MediaQuery.of(context).padding.top + 12),
        bottom: bottom,
        left: left,
        right: right,
        child: IgnorePointer(
          ignoring: false, // Allow taps on the banner itself
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    onTap?.call();
                    hide();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(234, 227, 242, 253),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            hide();
                            onDismiss?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    Overlay.of(context, rootOverlay: true).insert(_currentOverlay!);

    // Start animation
    controller.forward();

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (_isShowing) {
        _animateOutAndRemove(controller, onDismiss);
      }
    });
  }

  static void hide() {
    if (_currentOverlay != null && _isShowing) {
      _currentOverlay!.remove();
      _currentOverlay = null;
      _isShowing = false;
    }
  }

  static void _animateOutAndRemove(
    AnimationController controller,
    VoidCallback? onDismiss,
  ) async {
    if (!_isShowing) return;

    await controller.reverse();
    hide();
    onDismiss?.call();
    controller.dispose();
  }
}
