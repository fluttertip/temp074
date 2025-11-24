import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceWithProviderModel {
  final ServiceModel service;
  final UserModel provider;
  final DocumentSnapshot? lastDocument;

  ServiceWithProviderModel({
    required this.service,
    required this.provider,
    this.lastDocument,
  });

  ServiceWithProviderModel copyWith({
    ServiceModel? service,
    UserModel? provider,
    DocumentSnapshot? lastDocument,
  }) {
    return ServiceWithProviderModel(
      service: service ?? this.service,
      provider: provider ?? this.provider,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}
