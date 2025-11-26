
import 'package:flutter/material.dart';
import 'package:homeservice/models/booking_model.dart';

class VendorDashboardController {
	static Future<bool?> showStatusChangeDialog(
		BuildContext context, {
		required BookingStatus newStatus,
		required String title,
		String? message,
	}) {
		return showDialog<bool>(
			context: context,
			builder: (ctx) => AlertDialog(
				title: Text(title),
				content: Text(message ?? 'Do you want to change the booking status to ${newStatus.name}?'),
				actions: [
					TextButton(
						onPressed: () => Navigator.of(ctx).pop(false),
						child: const Text('Cancel'),
					),
					ElevatedButton(
						onPressed: () => Navigator.of(ctx).pop(true),
						child: const Text('Confirm'),
					),
				],
			),
		);
	}

	static Future<void> showSimpleMessage(BuildContext context, String message) async {
		ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
	}
}
