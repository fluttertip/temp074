import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/providers/location/location_provider.dart';
import 'package:provider/provider.dart';

class BuildHeader extends StatefulWidget {
  final bool isAuthenticated;
  final String? userDisplayName;
  final String ? userprofilePhotoUrl;

  const BuildHeader({
    super.key,
    required this.isAuthenticated,
    this.userDisplayName,
    this.userprofilePhotoUrl,
  });

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final locationProvider = Provider.of<LocationProvider>(
          context,
          listen: false,
        );
        locationProvider.getCurrentLocation();
      } catch (e) {
        print('Error initializing location provider: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: widget.isAuthenticated &&
                        widget.userprofilePhotoUrl != null
                    ? NetworkImage(widget.userprofilePhotoUrl!)
                    : const AssetImage('assets/images/person/person.png')
                        as ImageProvider,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.isAuthenticated && widget.userDisplayName != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${widget.userDisplayName!}",
                          style: AppTheme.headerUsername,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => locationProvider.refreshLocation(),
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xFF033e8a),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            locationProvider.isLoading
                                ? SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  )
                                : Text(
                                    locationProvider.currentLocation,
                                    style: AppTheme.headerLocation,
                                  ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () => locationProvider.refreshLocation(),
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xFF033e8a),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        locationProvider.isLoading
                            ? SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              )
                            : Text(
                                locationProvider.currentLocation,
                                style: AppTheme.headerLocation,
                              ),
                      ],
                    ),
            ),

            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.notifications_active_outlined),
              color: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        );
      },
    );
  }
}
