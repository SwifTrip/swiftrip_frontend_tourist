class TourPackage {
  final int id;
  final String title;
  final double basePrice;
  final String category;
  final List<String> images;

  TourPackage({
    required this.id,
    required this.title,
    required this.basePrice,
    required this.category,
    required this.images,
  });

  factory TourPackage.fromJson(Map<String, dynamic> json) {
    var imagesList = <String>[];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }
    return TourPackage(
      id: json['id'],
      title: json['title'],
      basePrice: (json['basePrice'] as num).toDouble(),
      category: json['category'],
      images: imagesList,
    );
  }
}