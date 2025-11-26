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
  
  final List<mealDetail> mealDetails;
  final List<stayDetail> stayDetails;
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
      mealDetails: (json['mealDetails'] as List<dynamic>?)
              ?.map((e) => mealDetail.fromJson(e))
              .toList() ??
          [],
      stayDetails: (json['stayDetails'] as List<dynamic>?)
              ?.map((e) => stayDetail.fromJson(e))
              .toList() ??
          [] ,
      transportDetails: json['transportDetails'] ?? [],
    );
  }
}

class mealDetail {
  final int id;
  final int itineraryItemId;
  final String mealType;
  final String cuisine;
  final bool included;

  mealDetail({
    required this.id,
    required this.itineraryItemId,
    required this.mealType,
    required this.cuisine,
    required this.included,
  });

  factory mealDetail.fromJson(Map<String, dynamic> json) {
    return mealDetail(
      id: json['id'] ?? 0,
      itineraryItemId: json['itineraryItemId'] ?? 0,
      mealType: json['mealType'] ?? '',
      cuisine: json['cuisine'] ?? '',
      included: json['included'] ?? false,
    );
  }
}

class stayDetail{
  final int id;
  final int itineraryItemId;
  final String stayType;
  final String? hotelName;
  final String? roomType;
  final double? rating;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? location;
  
  stayDetail({
    required this.id,
    required this.itineraryItemId,
    required this.stayType,
    required this.hotelName,
    required this.roomType,
    required this.rating,
    required this.checkInTime,
    required this.checkOutTime,
    required this.location,
  });

  factory stayDetail.fromJson(Map<String, dynamic> json) {
    return stayDetail(  
      id: json['id'] ?? 0,
      itineraryItemId: json['itineraryItemId'] ?? 0,
      stayType: json['stayType'] ?? '',
      hotelName: json['hotelName'],
      roomType: json['roomType'],
      rating: json['rating'] != null ? json['rating'].toDouble() : null,
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      location: json['location'],
    );
  }
}