class TourResponse {
  final bool success;
  final Agency agency;
  final BasePackage basePackage;

  TourResponse({
    required this.success,
    required this.agency,
    required this.basePackage,
  });

  factory TourResponse.fromJson(Map<String, dynamic> json) {
    return TourResponse(
      success: json['success'] ?? false,
      agency: Agency.fromJson(json['agency'] ?? {}),
      basePackage: BasePackage.fromJson(json['basePackage'] ?? {}),
    );
  }
}

class Agency {
  final int id;
  final String name;

  Agency({required this.id, required this.name});

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class BasePackage {
  final int id;
  final String title;
  final String description;
  final num basePrice; // Use num to handle both int and double
  final String category;
  final String currency;
  final String fromLocation;
  final String toLocation;
  final int? maxGroupSize; // Nullable based on JSON
  final List<dynamic> media;
  final List<Itinerary> itineraries;
  final Agency company;

  BasePackage({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.category,
    required this.currency,
    required this.fromLocation,
    required this.toLocation,
    this.maxGroupSize,
    required this.media,
    required this.itineraries,
    required this.company,
  });

  factory BasePackage.fromJson(Map<String, dynamic> json) {
    return BasePackage(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      basePrice: json['basePrice'] ?? 0,
      category: json['category'] ?? '',
      currency: json['currency'] ?? 'USD',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
      maxGroupSize: json['maxGroupSize'],
      media: json['media'] ?? [],
      itineraries: (json['itineraries'] as List<dynamic>?)
              ?.map((e) => Itinerary.fromJson(e))
              .toList() ??
          [],
      company: Agency.fromJson(json['company'] ?? {}),
    );
  }
}

class Itinerary {
  final int id;
  final int dayNumber;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<ItineraryItem> itineraryItems;

  Itinerary({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.description,
    this.startTime,
    this.endTime,
    required this.itineraryItems,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] ?? 0,
      dayNumber: json['dayNumber'] ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      itineraryItems: (json['itineraryItems'] as List<dynamic>?)
              ?.map((e) => ItineraryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ItineraryItem {
  final int id;
  final String name;
  final String type; // e.g., STAY, MEAL, ACTIVITY
  final String? otherType;
  final String description;
  final int duration;
  final String? location;
  final num price;
  final bool optional;
  final bool isAddOn;
  final int sortOrder;
  // Keeping these as dynamic lists for now as they are empty in the JSON
  final List<dynamic> mealDetails;
  final List<dynamic> stayDetails;
  final List<dynamic> transportDetails;

  ItineraryItem({
    required this.id,
    required this.name,
    required this.type,
    this.otherType,
    required this.description,
    required this.duration,
    this.location,
    required this.price,
    required this.optional,
    required this.isAddOn,
    required this.sortOrder,
    required this.mealDetails,
    required this.stayDetails,
    required this.transportDetails,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      otherType: json['otherType'],
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      location: json['location'],
      price: json['price'] ?? 0,
      optional: json['optional'] ?? false,
      isAddOn: json['isAddOn'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      mealDetails: json['mealDetails'] ?? [],
      stayDetails: json['stayDetails'] ?? [],
      transportDetails: json['transportDetails'] ?? [],
    );
  }
}