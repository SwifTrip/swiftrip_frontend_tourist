class ItinerarySelectionRequest {
  final int basePackageId;
  final DateTime startDate;
  final DateTime endDate;
  final int travelerCount;
  final List<ItineraryDaySelection> itineraries;

  ItinerarySelectionRequest({
    required this.basePackageId,
    required this.startDate,
    required this.endDate,
    required this.travelerCount,
    required this.itineraries,
  });

  factory ItinerarySelectionRequest.fromJson(Map<String, dynamic> json) {
    return ItinerarySelectionRequest(
      basePackageId: json['basePackageId'] as int? ?? 0,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      travelerCount: json['travelerCount'] as int? ?? 0,
      itineraries: (json['itineraries'] as List?)
              ?.map((entry) => ItineraryDaySelection.fromJson(entry as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basePackageId': basePackageId,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'travelerCount': travelerCount,
      'itineraries': itineraries.map((day) => day.toJson()).toList(),
    };
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;
}

class ItineraryDaySelection {
  final int dayNumber;
  final List<SelectedItemSelection> selectedItems;

  ItineraryDaySelection({
    required this.dayNumber,
    required this.selectedItems,
  });

  factory ItineraryDaySelection.fromJson(Map<String, dynamic> json) {
    return ItineraryDaySelection(
      dayNumber: json['dayNumber'] as int? ?? 0,
      selectedItems: (json['selectedItems'] as List?)
              ?.map((entry) => SelectedItemSelection.fromJson(entry as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'selectedItems': selectedItems.map((item) => item.toJson()).toList(),
    };
  }
}

class SelectedItemSelection {
  final int itemId;
  final bool included;

  SelectedItemSelection({
    required this.itemId,
    required this.included,
  });

  factory SelectedItemSelection.fromJson(Map<String, dynamic> json) {
    return SelectedItemSelection(
      itemId: json['itemId'] as int? ?? 0,
      included: json['included'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'included': included,
    };
  }
}
