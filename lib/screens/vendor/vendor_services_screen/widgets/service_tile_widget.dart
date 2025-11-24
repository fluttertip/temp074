import 'package:flutter/material.dart';
import 'package:homeservice/models/service_model.dart';

class ServiceTileWidget extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  const ServiceTileWidget({
    super.key,
    required this.service,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    service.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 3),

                      Text(
                        service.category,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        "Rs. ${service.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Row(
                        children: [
                          Icon(
                            service.isActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: service.isActive ? Colors.green : Colors.red,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            service.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11,
                              color: service.isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (onToggleStatus != null)
                  Expanded(
                    child: InkWell(
                      onTap: onToggleStatus,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              service.isActive ? Icons.pause : Icons.play_arrow,
                              color: service.isActive
                                  ? Colors.orange
                                  : Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service.isActive ? 'Deactivate' : 'Activate',
                              style: TextStyle(
                                fontSize: 11,
                                color: service.isActive
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                if (onToggleStatus != null &&
                    (onEdit != null || onDelete != null))
                  Container(width: 1, height: 20, color: Colors.grey[300]),

                if (onEdit != null)
                  Expanded(
                    child: InkWell(
                      onTap: onEdit,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                if (onEdit != null && onDelete != null)
                  Container(width: 1, height: 20, color: Colors.grey[300]),

                if (onDelete != null)
                  Expanded(
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
