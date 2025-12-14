class CustomTourModel {
  final int id;
  final int userId;
  final CompanyInfo company;
  final DateTime startDate;
  final DateTime endDate;
  final int travelerCount;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final List<CustomItinerary> customItineraries;

  CustomTourModel({
    required this.id,
    required this.userId,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.customItineraries,
  });

  factory CustomTourModel.fromJson(Map<String, dynamic> json) {
    return CustomTourModel(
      id: json['id'],
      userId: json['userId'],
      company: CompanyInfo.fromJson(json['company']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      travelerCount: json['travelerCount'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      customItineraries: (json['customItineraries'] as List)
          .map((i) => CustomItinerary.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'company': company.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travelerCount': travelerCount,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'customItineraries': customItineraries.map((i) => i.toJson()).toList(),
    };
  }
}

class CompanyInfo {
  final int id;
  final String name;

  CompanyInfo({required this.id, required this.name});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class CustomItinerary {
  final int id;
  final int dayNumber;
  final double estimatedCost;
  final int totalDuration;
  final List<CustomItineraryItem> items;

  CustomItinerary({
    required this.id,
    required this.dayNumber,
    required this.estimatedCost,
    required this.totalDuration,
    required this.items,
  });

  factory CustomItinerary.fromJson(Map<String, dynamic> json) {
    return CustomItinerary(
      id: json['id'],
      dayNumber: json['dayNumber'],
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      totalDuration: json['totalDuration'],
      items: (json['items'] as List)
          .map((item) => CustomItineraryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'estimatedCost': estimatedCost,
      'totalDuration': totalDuration,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class CustomItineraryItem {
  final int id;
  final int itineraryItemId;
  final String? name;
  final String? type;
  final double price;
  final int duration;
  final bool included;
  final bool isOptional;
  final int sortOrder;
  final ItemDetails? details;

  CustomItineraryItem({
    required this.id,
    required this.itineraryItemId,
    this.name,
    this.type,
    required this.price,
    required this.duration,
    required this.included,
    required this.isOptional,
    required this.sortOrder,
    this.details,
  });

  factory CustomItineraryItem.fromJson(Map<String, dynamic> json) {
    return CustomItineraryItem(
      id: json['id'],
      itineraryItemId: json['itineraryItemId'],
      name: json['name'],
      type: json['type'],
      price: (json['price'] as num).toDouble(),
      duration: json['duration'],
      included: json['included'],
      isOptional: json['isOptional'],
      sortOrder: json['sortOrder'],
      details: json['details'] != null
          ? ItemDetails.fromJson(json['details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itineraryItemId': itineraryItemId,
      'name': name,
      'type': type,
      'price': price,
      'duration': duration,
      'included': included,
      'isOptional': isOptional,
      'sortOrder': sortOrder,
      'details': details?.toJson(),
    };
  }
}

class ItemDetails {
  final List<dynamic> mealDetails;
  final List<dynamic> stayDetails;
  final List<dynamic> transportDetails;

  ItemDetails({
    required this.mealDetails,
    required this.stayDetails,
    required this.transportDetails,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      mealDetails: json['mealDetails'] ?? [],
      stayDetails: json['stayDetails'] ?? [],
      transportDetails: json['transportDetails'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealDetails': mealDetails,
      'stayDetails': stayDetails,
      'transportDetails': transportDetails,
    };
  }
}
