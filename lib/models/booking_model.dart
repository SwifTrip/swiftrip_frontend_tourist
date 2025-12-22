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
  final DateTime departureDate;
  final DateTime arrivalDate;
  final PackageInfo package;
  final CompanyInfo company;
  final DateTime createdAt;

  PublicTourBooking({
    required this.id,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.seats,
    required this.totalAmount,
    required this.departureDate,
    required this.arrivalDate,
    required this.package,
    required this.company,
    required this.createdAt,
  });

  factory PublicTourBooking.fromJson(Map<String, dynamic> json) {
    return PublicTourBooking(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'PUBLIC',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      seats: json['seats'] ?? 1,
      totalAmount: json['totalAmount'] ?? '0',
      departureDate: DateTime.parse(json['departureDate']),
      arrivalDate: DateTime.parse(json['arrivalDate']),
      package: PackageInfo.fromJson(json['package'] ?? {}),
      company: CompanyInfo.fromJson(json['company'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class PrivateTourBooking {
  final int id;
  final String type;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int travelerCount;
  final String? totalPrice;
  final int duration;
  final CompanyInfo company;
  final DateTime createdAt;

  PrivateTourBooking({
    required this.id,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    this.totalPrice,
    required this.duration,
    required this.company,
    required this.createdAt,
  });

  factory PrivateTourBooking.fromJson(Map<String, dynamic> json) {
    return PrivateTourBooking(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'PRIVATE',
      status: json['status'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      travelerCount: json['travelerCount'] ?? 1,
      totalPrice: json['totalPrice']?.toString(),
      duration: json['duration'] ?? 0,
      company: CompanyInfo.fromJson(json['company'] ?? {}),
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
