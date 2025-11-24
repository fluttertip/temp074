import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String providerId;
  final String category;
  final String title;
  final String description;
  final double price;
  final String rating;
  final String imageUrl;
  final bool admindelete;
  final bool adminapprove;
  final bool isActive;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.rating = '0.0',
    this.admindelete = false,
    this.adminapprove = false,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      providerId: map['providerId'],
      category: map['category'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      rating: map['rating'] ?? '0.0',
      price: (map['price'] as num).toDouble(),
      description: map['description'],
      admindelete: map['admindelete'] ?? false,
      adminapprove: map['adminapprove'] ?? false,

      isActive: map['isActive'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'category': category,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'description': description,
      'admindelete': admindelete,
      'adminapprove': adminapprove,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
