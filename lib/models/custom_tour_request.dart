class CustomTourRequest {
  final int companyId;
  final int basePackageId;
  final String startDate;
  final String endDate;
  final int travelerCount;
  final List<ItineraryDay> itineraries;

  CustomTourRequest({
    required this.companyId,
    required this.basePackageId,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    required this.itineraries,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'basePackageId': basePackageId,
      'startDate': startDate,
      'endDate': endDate,
      'travelerCount': travelerCount,
      'itineraries': itineraries.map((day) => day.toJson()).toList(),
    };
  }
}

class ItineraryDay {
  final int dayNumber;
  final List<int> selectedOptionalItems;

  ItineraryDay({required this.dayNumber, required this.selectedOptionalItems});

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'selectedOptionalItems': selectedOptionalItems,
    };
  }
}
