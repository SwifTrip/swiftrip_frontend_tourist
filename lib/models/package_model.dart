class PackageDetailsResponse {
  final bool success;
  final CustomizeItineraryModel data;

  PackageDetailsResponse({
    required this.success,
    required this.data,
  });

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PackageDetailsResponse(
      success: json['success'] ?? false,
      data: CustomizeItineraryModel.fromJson(json['data']),
    );
  }
}

class CustomizeItineraryModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final num basePrice;
  final String currency;
  final String fromLocation;
  final String toLocation;
  final bool isPublic;
  final int maxtravelers;
  final int mintravelers;
  final PackageInclusions includes;
  final Company company;
  final List<Media> media;
  final num duration;
  final List<DayItinerary> itineraries;
  final List<TourStay> stays;

  CustomizeItineraryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.currency,
    required this.fromLocation,
    required this.toLocation,
    required this.isPublic,
    required this.maxtravelers,
    required this.mintravelers,
    required this.includes,
    required this.company,
    required this.media,
    required this.duration,
    required this.itineraries,
    required this.stays,
  });

  factory CustomizeItineraryModel.fromJson(Map<String, dynamic> json) {
    return CustomizeItineraryModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      basePrice: json['basePrice'] ?? 0,
      currency: json['currency'] ?? 'PKR',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
      isPublic: json['isPublic'] ?? false,
      maxtravelers: json['maxtravelers'] ?? 0,
      mintravelers: json['mintravelers'] ?? 0,
      includes: PackageInclusions.fromJson(json['includes'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
      media: (json['media'] as List?)?.map((m) => Media.fromJson(m)).toList() ?? [],
      duration: json['duration'] ?? 0,
      itineraries: (json['itineraries'] as List?)
              ?.map((i) => DayItinerary.fromJson(i))
              .toList() ??
          [],
      stays: (json['stays'] as List?)?.map((s) => TourStay.fromJson(s)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'currency': currency,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'isPublic': isPublic,
      'maxtravelers': maxtravelers,
      'mintravelers': mintravelers,
      'includes': includes.toJson(),
      'company': company.toJson(),
      'media': media.map((m) => m.toJson()).toList(),
      'duration': duration,
      'itineraries': itineraries.map((i) => i.toJson()).toList(),
      'stays': stays.map((s) => s.toJson()).toList(),
    };
  }
}

class PackageInclusions {
  final String? guide;
  final String? meals;
  final bool permits;
  final String? transport;

  PackageInclusions({
    this.guide,
    this.meals,
    required this.permits,
    this.transport,
  });

  factory PackageInclusions.fromJson(Map<String, dynamic> json) {
    return PackageInclusions(
      guide: json['guide'],
      meals: json['meals'],
      permits: json['permits'] ?? false,
      transport: json['transport'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guide': guide,
      'meals': meals,
      'permits': permits,
      'transport': transport,
    };
  }
}

class Company {
  final int id;
  final String name;

  Company({
    required this.id,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Media {
  final int id;
  final String url;
  final String type;

  Media({
    required this.id,
    required this.url,
    required this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
    };
  }
}

class DayItinerary {
  final int id;
  final int dayNumber;
  final String title;
  final String description;
  final String dayType;
  final List<ItineraryItem> items;

  DayItinerary({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.dayType,
    required this.items,
  });

  factory DayItinerary.fromJson(Map<String, dynamic> json) {
    return DayItinerary(
      id: json['id'] ?? 0,
      dayNumber: json['dayNumber'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dayType: json['dayType'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => ItineraryItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'title': title,
      'description': description,
      'dayType': dayType,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ItineraryItem {
  final int id;
  final String name;
  final String type;
  final String description;
  final String? startTime;
  final String? endTime;
  final int duration;
  final String location;
  final num price;
  final bool optional;
  final bool isAddOn;
  final int sortOrder;
  final List<MealDetail> mealDetails;
  final List<TransportDetail> transportDetails;

  ItineraryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.startTime,
    this.endTime,
    required this.duration,
    required this.location,
    required this.price,
    required this.optional,
    required this.isAddOn,
    required this.sortOrder,
    required this.mealDetails,
    required this.transportDetails,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'] ?? 0,
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      optional: json['optional'] ?? false,
      isAddOn: json['isAddOn'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      mealDetails: (json['mealDetails'] as List?)
              ?.map((m) => MealDetail.fromJson(m))
              .toList() ??
          [],
      transportDetails: (json['transportDetails'] as List?)
              ?.map((t) => TransportDetail.fromJson(t))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'location': location,
      'price': price,
      'optional': optional,
      'isAddOn': isAddOn,
      'sortOrder': sortOrder,
      'mealDetails': mealDetails.map((m) => m.toJson()).toList(),
      'transportDetails': transportDetails.map((t) => t.toJson()).toList(),
    };
  }
}

class MealDetail {
  final int id;
  final int itineraryItemId;
  final String mealType;
  final String cuisine;
  final bool included;

  MealDetail({
    required this.id,
    required this.itineraryItemId,
    required this.mealType,
    required this.cuisine,
    required this.included,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      id: json['id'] ?? 0,
      itineraryItemId: json['itineraryItemId'] ?? 0,
      mealType: json['mealType'] ?? '',
      cuisine: json['cuisine'] ?? '',
      included: json['included'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itineraryItemId': itineraryItemId,
      'mealType': mealType,
      'cuisine': cuisine,
      'included': included,
    };
  }
}

class TransportDetail {
  final int id;
  final int itineraryItemId;
  final String vehicleType;
  final String pickupLocation;
  final String dropoffLocation;
  final bool included;

  TransportDetail({
    required this.id,
    required this.itineraryItemId,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.included,
  });

  factory TransportDetail.fromJson(Map<String, dynamic> json) {
    return TransportDetail(
      id: json['id'] ?? 0,
      itineraryItemId: json['itineraryItemId'] ?? 0,
      vehicleType: json['vehicleType'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      included: json['included'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itineraryItemId': itineraryItemId,
      'vehicleType': vehicleType,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'included': included,
    };
  }
}

class TourStay {
  final int id;
  final int tourPackageId;
  final String stayType;
  final String hotelName;
  final num rating;
  final int checkInDay;
  final int checkOutDay;
  final int rooms;
  final int bedsPerRoom;
  final String? createdAt;
  final String? updatedAt;
  final List<StayDetail> stayDetails;

  TourStay({
    required this.id,
    required this.tourPackageId,
    required this.stayType,
    required this.hotelName,
    required this.rating,
    required this.checkInDay,
    required this.checkOutDay,
    required this.rooms,
    required this.bedsPerRoom,
    this.createdAt,
    this.updatedAt,
    required this.stayDetails,
  });

  factory TourStay.fromJson(Map<String, dynamic> json) {
    return TourStay(
      id: json['id'] ?? 0,
      tourPackageId: json['tourPackageId'] ?? 0,
      stayType: json['stayType'] ?? '',
      hotelName: json['hotelName'] ?? '',
      rating: json['rating'] ?? 0.0,
      checkInDay: json['checkInDay'] ?? 0,
      checkOutDay: json['checkOutDay'] ?? 0,
      rooms: json['rooms'] ?? 0,
      bedsPerRoom: json['bedsPerRoom'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      stayDetails: (json['stayDetails'] as List?)
              ?.map((s) => StayDetail.fromJson(s))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tourPackageId': tourPackageId,
      'stayType': stayType,
      'hotelName': hotelName,
      'rating': rating,
      'checkInDay': checkInDay,
      'checkOutDay': checkOutDay,
      'rooms': rooms,
      'bedsPerRoom': bedsPerRoom,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stayDetails': stayDetails.map((s) => s.toJson()).toList(),
    };
  }
}

class StayDetail {
  final int id;
  final int tourStayId;
  final String roomType;
  final String checkInTime;
  final String checkOutTime;

  StayDetail({
    required this.id,
    required this.tourStayId,
    required this.roomType,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory StayDetail.fromJson(Map<String, dynamic> json) {
    return StayDetail(
      id: json['id'] ?? 0,
      tourStayId: json['tourStayId'] ?? 0,
      roomType: json['roomType'] ?? '',
      checkInTime: json['checkInTime'] ?? '',
      checkOutTime: json['checkOutTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tourStayId': tourStayId,
      'roomType': roomType,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
    };
  }
}
