import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;  
  final String name;

  final List<String> role;                          //['customer','vendor'] on registration,
  final String authProvider;                       //google on registration
  final bool isprofilecompletecustomer;           //false on registration
  final bool isprofilecompletevendor;            //false on registration
  final String activeRole;                      //customer on registration

  //common for both customer and vendors

  final String? gender;
  final String? address;
  final String? profilePhotoUrl;
  final String? coverPhotoUrl;
  final String? dateOfBirth;

  // Vendor profile extensions

  final String kycStatus;                                 // unverified | pending | approved | rejected (unverified on registration)
  final Map<String, bool> notificationSettings;          //'email': true, 'push': true, 'sms': false    (initally on registration)

  final String? aboutMe;
  final List<String>? skills;
  final List<String>? certifications;
  final List<String>? serviceAreas;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? kyc; // KYC details map
  final List<String>? kycDocumentUrls;
  final DateTime? kycSubmittedAt;
  final DateTime? kycApprovedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.authProvider,
    required this.activeRole,
    required this.isprofilecompletecustomer,
    required this.isprofilecompletevendor,
    required this.kycStatus,
    required this.notificationSettings,

    this.createdAt,
    this.updatedAt,
    this.address,
    this.profilePhotoUrl,
    this.coverPhotoUrl,
    this.gender,
    this.dateOfBirth,
    this.aboutMe,
    this.skills,
    this.certifications,
    this.serviceAreas,
    this.preferences,
    this.kyc,
    this.kycDocumentUrls,
    this.kycSubmittedAt,
    this.kycApprovedAt,
  });

  /// Factory constructor for creating initial user from Firebase User
  factory UserModel.initial({
    required String uid,
    required String email,
    required String name,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name,
      role: ['customer', 'vendor'], // Both roles from the start
      authProvider: 'google',
      activeRole: 'customer', // Default active role
      isprofilecompletecustomer: false,
      isprofilecompletevendor: false,
      kycStatus: 'unverified',
      notificationSettings: {'email': true, 'push': true, 'sms': false},
      profilePhotoUrl: null,
      coverPhotoUrl: null,
      address: null,
      gender: null,
      dateOfBirth: null,
      aboutMe: null,
      skills: [],
      certifications: [],
      serviceAreas: [],
      preferences: {},
      kyc: {},
      kycDocumentUrls: [],
      kycSubmittedAt: null,
      kycApprovedAt: null,
      createdAt: null, // Will be set by Firestore serverTimestamp
      updatedAt: null, // Will be set by Firestore serverTimestamp
    );
  }

  /// Factory constructor for creating UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: (data['role'] as List?)?.map((e) => e.toString()).toList() ?? ['customer'],
      authProvider: data['authProvider'] ?? 'google',
      activeRole: data['activeRole'] ?? 'customer',
      isprofilecompletecustomer: data['isprofilecompletecustomer'] ?? false,
      isprofilecompletevendor: data['isprofilecompletevendor'] ?? false,
      kycStatus: data['kycStatus']?.toString() ?? 'unverified',
      notificationSettings: (data['notificationSettings'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value == true),
      ) ?? {'email': true, 'push': true, 'sms': false},
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as dynamic).toDate()
          : null,
      address: data['address'],
      profilePhotoUrl: data['profilePhotoUrl'],
      coverPhotoUrl: data['coverPhotoUrl'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      aboutMe: data['aboutMe'],
      skills: (data['skills'] as List?)?.map((e) => e.toString()).toList(),
      certifications: (data['certifications'] as List?)?.map((e) => e.toString()).toList(),
      serviceAreas: (data['serviceAreas'] as List?)?.map((e) => e.toString()).toList(),
      preferences: (data['preferences'] as Map?)?.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      kyc: (data['kyc'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)),
      kycDocumentUrls: (data['kycDocumentUrls'] as List?)?.map((e) => e.toString()).toList(),
      kycSubmittedAt: data['kycSubmittedAt'] != null
          ? (data['kycSubmittedAt'] as dynamic).toDate()
          : null,
      kycApprovedAt: data['kycApprovedAt'] != null
          ? (data['kycApprovedAt'] as dynamic).toDate()
          : null,
    );
  }

  /// Convert UserModel to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'authProvider': authProvider,
      'activeRole': activeRole,
      'isprofilecompletecustomer': isprofilecompletecustomer,
      'isprofilecompletevendor': isprofilecompletevendor,
      'kycStatus': kycStatus,
      'notificationSettings': notificationSettings,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': Timestamp.now(),
      'address': address,
      'profilePhotoUrl': profilePhotoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'aboutMe': aboutMe,
      'skills': skills ?? [],
      'certifications': certifications ?? [],
      'serviceAreas': serviceAreas ?? [],
      'preferences': preferences ?? {},
      'kyc': kyc ?? {},
      'kycDocumentUrls': kycDocumentUrls ?? [],
      'kycSubmittedAt': kycSubmittedAt != null ? Timestamp.fromDate(kycSubmittedAt!) : null,
      'kycApprovedAt': kycApprovedAt != null ? Timestamp.fromDate(kycApprovedAt!) : null,
    };
  }

  /// Create a copy of UserModel with optional field overrides
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    List<String>? role,
    String? authProvider,
    String? activeRole,
    bool? isprofilecompletecustomer,
    bool? isprofilecompletevendor,
    String? kycStatus,
    Map<String, bool>? notificationSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? gender,
    String? address,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    String? dateOfBirth,
    String? aboutMe,
    List<String>? skills,
    List<String>? certifications,
    List<String>? serviceAreas,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? kyc,
    List<String>? kycDocumentUrls,
    DateTime? kycSubmittedAt,
    DateTime? kycApprovedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      authProvider: authProvider ?? this.authProvider,
      activeRole: activeRole ?? this.activeRole,
      isprofilecompletecustomer: isprofilecompletecustomer ?? this.isprofilecompletecustomer,
      isprofilecompletevendor: isprofilecompletevendor ?? this.isprofilecompletevendor,
      kycStatus: kycStatus ?? this.kycStatus,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      aboutMe: aboutMe ?? this.aboutMe,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      preferences: preferences ?? this.preferences,
      kyc: kyc ?? this.kyc,
      kycDocumentUrls: kycDocumentUrls ?? this.kycDocumentUrls,
      kycSubmittedAt: kycSubmittedAt ?? this.kycSubmittedAt,
      kycApprovedAt: kycApprovedAt ?? this.kycApprovedAt,
    );
  }

  /// Convert UserModel to a Map (useful for JSON serialization or local storage)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'authProvider': authProvider,
      'activeRole': activeRole,
      'isprofilecompletecustomer': isprofilecompletecustomer,
      'isprofilecompletevendor': isprofilecompletevendor,
      'kycStatus': kycStatus,
      'notificationSettings': notificationSettings,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'gender': gender,
      'address': address,
      'profilePhotoUrl': profilePhotoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'dateOfBirth': dateOfBirth,
      'aboutMe': aboutMe,
      'skills': skills,
      'certifications': certifications,
      'serviceAreas': serviceAreas,
      'preferences': preferences,
      'kyc': kyc,
      'kycDocumentUrls': kycDocumentUrls,
      'kycSubmittedAt': kycSubmittedAt?.toIso8601String(),
      'kycApprovedAt': kycApprovedAt?.toIso8601String(),
    };
  }

  /// Create UserModel from a Map (useful for JSON deserialization)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: List<String>.from(map['role'] ?? ['customer']),
      authProvider: map['authProvider'] ?? 'google',
      activeRole: map['activeRole'] ?? 'customer',
      isprofilecompletecustomer: map['isprofilecompletecustomer'] ?? false,
      isprofilecompletevendor: map['isprofilecompletevendor'] ?? false,
      kycStatus: map['kycStatus'] ?? 'unverified',
      notificationSettings: Map<String, bool>.from(map['notificationSettings'] ?? {'email': true, 'push': true, 'sms': false}),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      gender: map['gender'],
      address: map['address'],
      profilePhotoUrl: map['profilePhotoUrl'],
      coverPhotoUrl: map['coverPhotoUrl'],
      dateOfBirth: map['dateOfBirth'],
      aboutMe: map['aboutMe'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,
      certifications: map['certifications'] != null ? List<String>.from(map['certifications']) : null,
      serviceAreas: map['serviceAreas'] != null ? List<String>.from(map['serviceAreas']) : null,
      preferences: map['preferences'] != null ? Map<String, dynamic>.from(map['preferences']) : null,
      kyc: map['kyc'] != null ? Map<String, dynamic>.from(map['kyc']) : null,
      kycDocumentUrls: map['kycDocumentUrls'] != null ? List<String>.from(map['kycDocumentUrls']) : null,
      kycSubmittedAt: map['kycSubmittedAt'] != null ? DateTime.parse(map['kycSubmittedAt']) : null,
      kycApprovedAt: map['kycApprovedAt'] != null ? DateTime.parse(map['kycApprovedAt']) : null,
    );
  }
}