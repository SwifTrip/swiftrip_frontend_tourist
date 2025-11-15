import 'package:swift_trip_app/models/searchAgency.dart';

class Agency {
  final int companyId;
  final String companyName;
  final List<TourPackage> packages;

  Agency({
    required this.companyId,
    required this.companyName,
    required this.packages,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    var packagesList = <TourPackage>[];
    if (json['packages'] != null) {
      packagesList = List<Map<String, dynamic>>.from(json['packages'])
          .map((pkg) => TourPackage.fromJson(pkg))
          .toList();
    }

    return Agency(
      companyId: json['companyId'],
      companyName: json['companyName'],
      packages: packagesList,
    );
  }
}