class HardcodedServicesModel {
  final String id;
  final String category;
  final String categoryId;
  final DateTime createdAt;
  final String heroImageUrl;
  final List<String> imageUrls;
  final bool isActive;
  final ServiceMetadata metadata;
  final List<ServiceSubcategory> subcategories;
  final String subcategory;
  final int totalServices;
  final DateTime updatedAt;

  HardcodedServicesModel({
    required this.id,
    required this.category,
    required this.categoryId,
    required this.createdAt,
    required this.heroImageUrl,
    required this.imageUrls,
    required this.isActive,
    required this.metadata,
    required this.subcategories,
    required this.subcategory,
    required this.totalServices,
    required this.updatedAt,
  });

  factory HardcodedServicesModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return HardcodedServicesModel(
      id: docId,
      category: map['category'] ?? '',
      categoryId: map['categoryId'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      heroImageUrl: map['heroImageUrl'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      isActive: map['isActive'] ?? true,
      metadata: ServiceMetadata.fromMap(map['metadata'] ?? {}),
      subcategories:
          (map['subcategories'] as List<dynamic>?)
              ?.map((item) => ServiceSubcategory.fromMap(item))
              .toList() ??
          [],
      subcategory: map['subcategory'] ?? 'General',
      totalServices: map['totalServices'] ?? 0,
      updatedAt: map['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'heroImageUrl': heroImageUrl,
      'imageUrls': imageUrls,
      'isActive': isActive,
      'metadata': metadata.toMap(),
      'subcategories': subcategories.map((item) => item.toMap()).toList(),
      'subcategory': subcategory,
      'totalServices': totalServices,
      'updatedAt': updatedAt,
    };
  }
}

class ServiceMetadata {
  final double averagePrice;
  final PriceRange priceRange;

  ServiceMetadata({required this.averagePrice, required this.priceRange});

  factory ServiceMetadata.fromMap(Map<String, dynamic> map) {
    return ServiceMetadata(
      averagePrice: (map['averagePrice'] ?? 0).toDouble(),
      priceRange: PriceRange.fromMap(map['priceRange'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {'averagePrice': averagePrice, 'priceRange': priceRange.toMap()};
  }
}

class PriceRange {
  final double max;
  final double min;

  PriceRange({required this.max, required this.min});

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      max: (map['max'] ?? 0).toDouble(),
      min: (map['min'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'max': max, 'min': min};
  }
}

class ServiceSubcategory {
  final String description;
  final String id;
  final String imageUrl;
  final bool isActive;
  final List<String> keywords;
  final String name;
  final ServicePricing pricing;
  final String subcategory;

  ServiceSubcategory({
    required this.description,
    required this.id,
    required this.imageUrl,
    required this.isActive,
    required this.keywords,
    required this.name,
    required this.pricing,
    required this.subcategory,
  });

  factory ServiceSubcategory.fromMap(Map<String, dynamic> map) {
    return ServiceSubcategory(
      description: map['description'] ?? '',
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isActive: map['isActive'] ?? true,
      keywords: List<String>.from(map['keywords'] ?? []),
      name: map['name'] ?? '',
      pricing: ServicePricing.fromMap(map['pricing'] ?? {}),
      subcategory: map['subcategory'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'id': id,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'keywords': keywords,
      'name': name,
      'pricing': pricing.toMap(),
      'subcategory': subcategory,
    };
  }
}

class ServicePricing {
  final double basePrice;
  final String currency;
  final double maxPrice;
  final double minPrice;
  final String unit;

  ServicePricing({
    required this.basePrice,
    required this.currency,
    required this.maxPrice,
    required this.minPrice,
    required this.unit,
  });

  factory ServicePricing.fromMap(Map<String, dynamic> map) {
    return ServicePricing(
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'NPR',
      maxPrice: (map['maxPrice'] ?? 0).toDouble(),
      minPrice: (map['minPrice'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'Per job',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basePrice': basePrice,
      'currency': currency,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'unit': unit,
    };
  }
}
