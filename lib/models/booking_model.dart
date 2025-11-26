import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus {
  pending,
  confirmed,
  rejected,
  cancelled,
  inProgress,
  completed,
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromMap(Map<String, dynamic> map) => Coordinates(
    lat: (map['lat'] as num).toDouble(),
    lng: (map['lng'] as num).toDouble(),
  );

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng};
}

class ServiceDetails {
  final String serviceId;
  final String title;
  final String imageUrl;
  final String address;
  final Coordinates? coordinates;
  final String? additionalInfo;

  ServiceDetails({
    required this.serviceId,
    required this.title,
    required this.imageUrl,
    required this.address,
    this.coordinates,
    this.additionalInfo,
  });

  factory ServiceDetails.fromMap(Map<String, dynamic> map) => ServiceDetails(
    serviceId: map['serviceId'],
    title: map['title'],
    imageUrl: map['imageUrl'],
    address: map['address'],
    coordinates: map['coordinates'] != null
        ? Coordinates.fromMap(map['coordinates'])
        : null,
    additionalInfo: map['additionalInfo'],
  );

  Map<String, dynamic> toMap() => {
    'serviceId': serviceId,
    'title': title,
    'imageUrl': imageUrl,
    'address': address,
    if (coordinates != null) 'coordinates': coordinates!.toMap(),
    if (additionalInfo != null) 'additionalInfo': additionalInfo,
  };
}

class Pricing {
  final double basePrice;
  final double finalPrice;
  final double? discount;
  final String? couponId;

  Pricing({
    required this.basePrice,
    required this.finalPrice,
    this.discount,
    this.couponId,
  });

  factory Pricing.fromMap(Map<String, dynamic> map) => Pricing(
    basePrice: (map['basePrice'] as num).toDouble(),
    finalPrice: (map['finalPrice'] as num).toDouble(),
    discount: map['discount'] != null
        ? (map['discount'] as num).toDouble()
        : null,
    couponId: map['couponId'],
  );

  Map<String, dynamic> toMap() => {
    'basePrice': basePrice,
    'finalPrice': finalPrice,
    if (discount != null) 'discount': discount,
    if (couponId != null) 'couponId': couponId,
  };
}

class ContactInfo {
  final String name;

  ContactInfo({required this.name,});

  factory ContactInfo.fromMap(Map<String, dynamic> map) =>
      ContactInfo(name: map['name'], );

  Map<String, dynamic> toMap() => {'name': name, };
}

class Timeline {
  final DateTime requestedAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  Timeline({
    required this.requestedAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory Timeline.fromMap(Map<String, dynamic> map) => Timeline(
    requestedAt: (map['requestedAt'] as Timestamp).toDate(),
    confirmedAt: map['confirmedAt'] != null
        ? (map['confirmedAt'] as Timestamp).toDate()
        : null,
    startedAt: map['startedAt'] != null
        ? (map['startedAt'] as Timestamp).toDate()
        : null,
    completedAt: map['completedAt'] != null
        ? (map['completedAt'] as Timestamp).toDate()
        : null,
    cancelledAt: map['cancelledAt'] != null
        ? (map['cancelledAt'] as Timestamp).toDate()
        : null,
  );

  Map<String, dynamic> toMap() => {
    'requestedAt': requestedAt,
    if (confirmedAt != null) 'confirmedAt': confirmedAt,
    if (startedAt != null) 'startedAt': startedAt,
    if (completedAt != null) 'completedAt': completedAt,
    if (cancelledAt != null) 'cancelledAt': cancelledAt,
  };
}

class BookingModel {
  final String id;
  final String customerId;
  final String vendorId;
  final BookingStatus status;
  final DateTime scheduledDateTime;
  final String? bookingNotes;
  final ServiceDetails serviceDetails;
  final Pricing pricing;
  final bool agreementStatus;
  final ContactInfo customerContact;
  final ContactInfo vendorContact;
  final Timeline timeline;
  final String? paymentId;
  final bool isPaymentCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.vendorId,
    required this.status,
    required this.scheduledDateTime,
    this.bookingNotes,
    required this.serviceDetails,
    required this.pricing,
    required this.agreementStatus,
    required this.customerContact,
    required this.vendorContact,
    required this.timeline,
   this.paymentId,
    required this.isPaymentCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      customerId: data['customerId'],
      vendorId: data['vendorId'],
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      scheduledDateTime: (data['scheduledDateTime'] as Timestamp).toDate(),
      bookingNotes: data['bookingNotes'],
      serviceDetails: ServiceDetails.fromMap(data['serviceDetails']),
      pricing: Pricing.fromMap(data['pricing']),
      agreementStatus: data['agreementStatus'] ?? false,
      customerContact: ContactInfo.fromMap(data['customerContact']),
      vendorContact: ContactInfo.fromMap(data['vendorContact']),
      timeline: Timeline.fromMap(data['timeline']),
      paymentId: data['paymentId'] ?? '',
      isPaymentCompleted: data['isPaymentCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'customerId': customerId,
    'vendorId': vendorId,
    'status': status.name,
    'scheduledDateTime': scheduledDateTime,
    if (bookingNotes != null) 'bookingNotes': bookingNotes,
    'serviceDetails': serviceDetails.toMap(),
    'pricing': pricing.toMap(),
    'agreementStatus': agreementStatus,
    'customerContact': customerContact.toMap(),
    'vendorContact': vendorContact.toMap(),
    'timeline': timeline.toMap(),
    'paymentId': paymentId,
    'isPaymentCompleted': isPaymentCompleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
