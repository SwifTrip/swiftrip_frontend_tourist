import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:swift_trip_app/widgets/custom_bottom_bar.dart';

class PlanningScreen extends StatefulWidget {
  final TourResponse tourResponse;

  const PlanningScreen({super.key, required this.tourResponse});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  @override
  Widget build(BuildContext context) {
    final base = widget.tourResponse.basePackage;
    final itineraries = base.itineraries;

    return Scaffold(
      appBar: CustomAppBar(currentStep: 2),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),

            /// -------------------------
            /// PACKAGE HEADER
            /// -------------------------
            PackageHeader(base: base),

            const SizedBox(height: 10),

            /// -------------------------
            /// ITINERARIES
            /// -------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: itineraries
                    .map((day) => ItineraryDayCard(itinerary: day))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }
}

///////////////////////////////////////////////////////////
///                 PACKAGE HEADER                      ///
///////////////////////////////////////////////////////////

class PackageHeader extends StatelessWidget {
  final BasePackage base;

  const PackageHeader({super.key, required this.base});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              base.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// Description
            Text(
              base.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 12),

            /// Chips (Category + Price + Locations)
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(base.category),
                  backgroundColor: Colors.blue.shade50,
                ),
                Chip(
                  label: Text("${base.currency} ${base.basePrice}"),
                  backgroundColor: Colors.green.shade50,
                ),
                Chip(
                  label: Text("${base.fromLocation} → ${base.toLocation}"),
                  backgroundColor: Colors.purple.shade50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
///                ITINERARY DAY CARD                   ///
///////////////////////////////////////////////////////////

class ItineraryDayCard extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryDayCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Day Title
            Text(
              itinerary.title ?? "Day ${itinerary.dayNumber}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// Description
            if (itinerary.description != null)
              Text(
                itinerary.description!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),

            const SizedBox(height: 12),

            /// Items List (Meals, Activities, Stay)
            Column(
              children: itinerary.itineraryItems
                  .map((item) => ItineraryItemTile(item: item))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
///                ITINERARY ITEM TILE                  ///
///////////////////////////////////////////////////////////

class ItineraryItemTile extends StatelessWidget {
  final ItineraryItem item;

  const ItineraryItemTile({super.key, required this.item});

  IconData _getIcon(String type) {
    switch (type) {
      case "MEAL":
        return Icons.restaurant;
      case "STAY":
        return Icons.hotel;
      case "ACTIVITY":
        return Icons.hiking;
      default:
        return Icons.info;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case "MEAL":
        return Colors.orange;
      case "STAY":
        return Colors.blue;
      case "ACTIVITY":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(item.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Icon(_getIcon(item.type), color: color, size: 30),

        /// Name
        title: Text(
          item.name ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        /// Description
        subtitle: Text(
          item.description ?? "",
          style: TextStyle(color: Colors.grey.shade600),
        ),

        /// Price
        trailing: Text(
          item.price == 0 ? "Free" : "\$${item.price}",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
