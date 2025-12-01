
import 'package:flutter/material.dart';

class TourPackage {
  final String title;
  final String price;
  final String duration;
  final String rating;
  final int reviewsCount;
  final String imageUrl;
  final List<String> highlights;
  final List<Map<String, dynamic>> included; // IconData specific to generic strings
  final List<String> perfectFor;
  final List<ItineraryDay> itinerary;
  final List<Review> reviews;

  TourPackage({
    required this.title,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.highlights,
    required this.included,
    required this.perfectFor,
    required this.itinerary,
    required this.reviews,
  });
}

class ItineraryDay {
  final String day;
  final String title;
  final String subtitle;
  final IconData icon;

  ItineraryDay({
    required this.day,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class Review {
  final String initial;
  final String name;
  final String date;
  final int stars;
  final String comment;

  Review({
    required this.initial,
    required this.name,
    required this.date,
    required this.stars,
    required this.comment,
  });
}
