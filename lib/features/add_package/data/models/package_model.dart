class PackageModel {
  final String? id;
  final String categoryName;
  final String packageName;

  final String type;
  final double price;
  final String duration;
  final String highlights;
  final List<String> images;
  final List<String> inclusions;
  final List<String> standardInclusions;
  final List<String> exclusions;
  final List<String> accommodation;
  final List<String> meals;
  final List<String> tourManager;
  final Map<String, ItineraryDay> itinerary;
  final DateTime? createdAt;

  PackageModel({
    this.id,
    this.categoryName = '',
    required this.packageName,

    required this.type,
    required this.price,
    required this.duration,
    required this.highlights,
    required this.images,
    required this.inclusions,
    required this.standardInclusions,
    required this.exclusions,
    required this.accommodation,
    required this.meals,
    required this.tourManager,
    required this.itinerary,
    this.createdAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json, String id) {
    return PackageModel(
      id: id,
      categoryName: json['categoryName'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',

      type: json['type'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] as String? ?? '',
      highlights: json['highlights'] as String? ?? '',
      images: List<String>.from(json['images'] ?? []),
      inclusions: List<String>.from(json['inclusions'] ?? []),
      standardInclusions: List<String>.from(json['standardInclusions'] ?? []),
      exclusions: List<String>.from(json['exclusions'] ?? []),
      accommodation: List<String>.from(json['accommodation'] ?? []),
      meals: List<String>.from(json['meals'] ?? []),
      tourManager: List<String>.from(json['tourManager'] ?? []),
      itinerary:
          (json['itinerary'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              ItineraryDay.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'packageName': packageName,

      'type': type,
      'price': price,
      'duration': duration,
      'highlights': highlights,
      'images': images,
      'inclusions': inclusions,
      'standardInclusions': standardInclusions,
      'exclusions': exclusions,
      'accommodation': accommodation,
      'meals': meals,
      'tourManager': tourManager,
      'itinerary': itinerary.map((key, value) => MapEntry(key, value.toJson())),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class ItineraryDay {
  final String description;
  final List<String> images;

  ItineraryDay({required this.description, required this.images});

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      description: json['description'] as String? ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'description': description, 'images': images};
  }
}
