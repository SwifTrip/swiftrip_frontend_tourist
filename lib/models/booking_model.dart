class BookingsResponse {
  final bool success;
  final BookingsData data;

  BookingsResponse({required this.success, required this.data});

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    return BookingsResponse(
      success: json['success'] ?? false,
      data: BookingsData.fromJson(json['data'] ?? {}),
    );
  }
}

class BookingsData {
  final List<PublicTourBooking> publicTours;
  final List<PrivateTourBooking> privateTours;

  BookingsData({required this.publicTours, required this.privateTours});

  factory BookingsData.fromJson(Map<String, dynamic> json) {
    return BookingsData(
      publicTours:
          (json['publicTours'] as List<dynamic>?)
              ?.map((item) => PublicTourBooking.fromJson(item))
              .toList() ??
          [],
      privateTours:
          (json['privateTours'] as List<dynamic>?)
              ?.map((item) => PrivateTourBooking.fromJson(item))
              .toList() ??
          [],
    );
  }

  // Get all bookings combined
  List<dynamic> getAllBookings() {
    return [...publicTours, ...privateTours];
  }
}

class PublicTourBooking {
  final int id;
  final String type;
  final String status;
  final String paymentStatus;
  final int seats;
  final String totalAmount;
  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final PackageInfo? package;
  final CompanyInfo? company;
  final List<BookingItinerary>? itineraries;
  final DateTime createdAt;

  PublicTourBooking({
    required this.id,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.seats,
    required this.totalAmount,
    this.departureDate,
    this.arrivalDate,
    this.package,
    this.company,
    this.itineraries,
    required this.createdAt,
  });

  factory PublicTourBooking.fromJson(Map<String, dynamic> json) {
    return PublicTourBooking(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'PUBLIC',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      seats: json['seats'] ?? 1,
      totalAmount: (json['totalAmount'] ?? 0).toString(),
      departureDate: json['departureDate'] != null
          ? DateTime.tryParse(json['departureDate'].toString())
          : null,
      arrivalDate: json['arrivalDate'] != null
          ? DateTime.tryParse(json['arrivalDate'].toString())
          : null,
      package: json['package'] != null
          ? PackageInfo.fromJson(json['package'])
          : null,
      company: json['company'] != null
          ? CompanyInfo.fromJson(json['company'])
          : null,
      itineraries: (json['itineraries'] as List<dynamic>?)
          ?.map((i) => BookingItinerary.fromJson(i))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class PrivateTourBooking {
  final int id;
  final String type;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  // Backend may return departure/arrival for private bookings as well
  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final int travelerCount;
  // backend may return seats and totalAmount for private bookings
  final int? seats;
  final String? totalPrice;
  final String? totalAmount;
  final int duration;
  final CompanyInfo? company;
  final PackageInfo? package;
  final List<BookingItinerary>? itineraries;
  final DateTime createdAt;

  PrivateTourBooking({
    required this.id,
    required this.type,
    required this.status,
    this.startDate,
    this.endDate,
    this.departureDate,
    this.arrivalDate,
    required this.travelerCount,
    this.seats,
    this.totalPrice,
    this.totalAmount,
    required this.duration,
    this.company,
    this.package,
    this.itineraries,
    required this.createdAt,
  });

  factory PrivateTourBooking.fromJson(Map<String, dynamic> json) {
    return PrivateTourBooking(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'PRIVATE',
      status: json['status'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      departureDate: json['departureDate'] != null
          ? DateTime.tryParse(json['departureDate'].toString())
          : null,
      arrivalDate: json['arrivalDate'] != null
          ? DateTime.tryParse(json['arrivalDate'].toString())
          : null,
      travelerCount: json['travelerCount'] ?? 1,
      seats: json['seats'] ?? (json['travelerCount'] as int?),
      totalPrice: json['totalPrice']?.toString(),
      totalAmount: json['totalAmount']?.toString(),
      duration: json['duration'] ?? 0,
      company: json['company'] != null
          ? CompanyInfo.fromJson(json['company'])
          : null,
      package: json['package'] != null
          ? PackageInfo.fromJson(json['package'])
          : null,
      itineraries: (json['itineraries'] as List<dynamic>?)
          ?.map((i) => BookingItinerary.fromJson(i))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class PackageInfo {
  final int id;
  final String title;
  final String fromLocation;
  final String toLocation;
  final String? coverImage;

  PackageInfo({
    required this.id,
    required this.title,
    required this.fromLocation,
    required this.toLocation,
    this.coverImage,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    return PackageInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      fromLocation: json['fromLocation'] ?? '',
      toLocation: json['toLocation'] ?? '',
      coverImage: json['coverImage'],
    );
  }
}

class CompanyInfo {
  final int id;
  final String name;

  CompanyInfo({required this.id, required this.name});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class BookingItinerary {
  final int id;
  final int dayNumber;
  final String title;
  final String? description;
  final String? dayType;
  final List<BookingItineraryItem>? items;
  final DateTime? actualDate;

  BookingItinerary({
    required this.id,
    required this.dayNumber,
    required this.title,
    this.description,
    this.dayType,
    this.items,
    this.actualDate,
  });

  factory BookingItinerary.fromJson(Map<String, dynamic> json) {
    return BookingItinerary(
      id: json['id'] ?? 0,
      dayNumber: json['dayNumber'] ?? 0,
      title: json['title'] ?? 'Day ${json['dayNumber'] ?? 1}',
      description: json['description'],
      dayType: json['dayType'],
      items: (json['items'] as List<dynamic>?)
          ?.map((i) => BookingItineraryItem.fromJson(i))
          .toList(),
      actualDate: json['actualDate'] != null
          ? DateTime.tryParse(json['actualDate'].toString())
          : null,
    );
  }
}

class BookingItineraryItem {
  final int id;
  final String name;
  final String? type;
  final String? description;
  final String? startTime;
  final String? endTime;
  final int? duration;
  final String? location;
  final num? price;

  BookingItineraryItem({
    required this.id,
    required this.name,
    this.type,
    this.description,
    this.startTime,
    this.endTime,
    this.duration,
    this.location,
    this.price,
  });

  factory BookingItineraryItem.fromJson(Map<String, dynamic> json) {
    return BookingItineraryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'],
      description: json['description'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      location: json['location'],
      price: json['price'],
    );
  }
}
