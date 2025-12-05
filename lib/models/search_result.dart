// Search result model for tour packages
class agencyResult {
  final bool success;
  final List<TourPackageResult> data;
  final PaginationInfo pagination;

  agencyResult({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory agencyResult.fromJson(Map<String, dynamic> json) {
    return agencyResult(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List?)
              ?.map((item) =>
                  TourPackageResult.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(
        (json['pagination'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

// Individual tour package result from search
class TourPackageResult {
  final int id;
  final String title;
  final String description;
  final String category;
  final num basePrice;
  final String currency;
  final String fromLocation;
  final String toLocation;
  final bool isPublic;
  final int maxGroupSize;
  final num duration;
  final PackageIncludes includes;
  final String? coverImage;
  final Company company;
  final String? nextDeparture;

  TourPackageResult({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.currency,
    required this.fromLocation,
    required this.toLocation,
    required this.isPublic,
    required this.maxGroupSize,
    required this.duration,
    required this.includes,
    this.coverImage,
    required this.company,
    this.nextDeparture,
  });

  factory TourPackageResult.fromJson(Map<String, dynamic> json) {
    return TourPackageResult(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      basePrice: json['basePrice'] as num? ?? 0,
      currency: json['currency'] as String? ?? 'PKR',
      fromLocation: json['fromLocation'] as String? ?? '',
      toLocation: json['toLocation'] as String? ?? '',
      isPublic: json['isPublic'] as bool? ?? true,
      maxGroupSize: json['maxGroupSize'] as int? ?? 1,
      duration: json['duration'] as num? ?? 0,
      includes: PackageIncludes.fromJson(
        (json['includes'] as Map<String, dynamic>?) ?? {},
      ),
      coverImage: json['coverImage'] as String?,
      company: Company.fromJson(
        (json['company'] as Map<String, dynamic>?) ?? {},
      ),
      nextDeparture: json['nextDeparture'] as String?,
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
      'maxGroupSize': maxGroupSize,
      'duration': duration,
      'includes': includes.toJson(),
      'coverImage': coverImage,
      'company': company.toJson(),
      'nextDeparture': nextDeparture,
    };
  }
}

// Company/Agency information
class Company {
  final int id;
  final String name;

  Company({
    required this.id,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Agency',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Package inclusions details
class PackageIncludes {
  final String? guide;
  final String? meals;
  final bool permits;
  final String? transport;
  final String? accommodation;

  PackageIncludes({
    this.guide,
    this.meals,
    this.permits = false,
    this.transport,
    this.accommodation,
  });

  factory PackageIncludes.fromJson(Map<String, dynamic> json) {
    return PackageIncludes(
      guide: json['guide'] as String?,
      meals: json['meals'] as String?,
      permits: json['permits'] as bool? ?? false,
      transport: json['transport'] as String?,
      accommodation: json['accommodation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guide': guide,
      'meals': meals,
      'permits': permits,
      'transport': transport,
      'accommodation': accommodation,
    };
  }
}

// Pagination information
class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}
