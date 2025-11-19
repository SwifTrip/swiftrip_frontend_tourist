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
  int travelerCount = 1;
  DateTimeRange? dateRange;
  Map<int, List<int>> selectedOptionalItems = {};

  @override
  void initState() {
    super.initState();
    // Initialize selectedOptionalItems for each day
    for (var day in widget.tourResponse.basePackage.itineraries) {
      selectedOptionalItems[day.dayNumber] = [];
    }
  }

  void toggleItemSelection(int dayNumber, int itemId, bool selected) {
    final list = selectedOptionalItems[dayNumber] ?? [];
    setState(() {
      if (selected) {
        if (!list.contains(itemId)) list.add(itemId);
      } else {
        list.remove(itemId);
      }
      selectedOptionalItems[dayNumber] = list;
    });
  }

  double computeAddOnTotal() {
    double sum = 0.0;
    for (var day in widget.tourResponse.basePackage.itineraries) {
      final ids = selectedOptionalItems[day.dayNumber] ?? [];
      for (var item in day.itineraryItems) {
        if (ids.contains(item.id)) {
          sum += item.price.toDouble();
        }
      }
    }
    return sum;
  }

  double computeBaseTotal() {
    return widget.tourResponse.basePackage.basePrice.toDouble() * travelerCount;
  }

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
  final List<int> selectedItemIds;
  final Function(int itemId, bool selected)? onToggleItem;

  const ItineraryDayCard({
    super.key,
    required this.itinerary,
    this.selectedItemIds = const [],
    this.onToggleItem,
  });

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
              itinerary.title.isNotEmpty
                  ? itinerary.title
                  : "Day ${itinerary.dayNumber}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// Description
            if (itinerary.description.isNotEmpty)
              Text(
                itinerary.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),

            const SizedBox(height: 12),

            /// Items List (Meals, Activities, Stay)
            Column(
              children: itinerary.itineraryItems.map((item) {
                final selected = selectedItemIds.contains(item.id);
                return ItineraryItemTile(
                  item: item,
                  selected: selected,
                  onToggle: item.optional
                      ? (sel) {
                          if (onToggleItem != null) onToggleItem!(item.id, sel);
                        }
                      : null,
                );
              }).toList(),
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
  final bool selected;
  final ValueChanged<bool>? onToggle;

  const ItineraryItemTile({
    super.key,
    required this.item,
    this.selected = false,
    this.onToggle,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case "MEAL":
        return Icons.restaurant;
      case "STAY":
        return Icons.hotel;
      case "ACTIVITY":
        return Icons.hiking;
      case "TRANSPORT":
        return Icons.directions_car;
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
      case "TRANSPORT":
        return Colors.purple;
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
        color: color.withOpacity(selected ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: selected ? Border.all(color: color, width: 2) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Icon(_getIcon(item.type), color: color, size: 30),

        /// Name with optional badge
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name.isNotEmpty ? item.name : "Unnamed",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (item.optional)
              const Chip(
                label: Text('Optional', style: TextStyle(fontSize: 10)),
                padding: EdgeInsets.symmetric(horizontal: 6),
                backgroundColor: Colors.amber,
              ),
          ],
        ),

        /// Description
        subtitle: Text(
          item.description.isNotEmpty ? item.description : "No description",
          style: TextStyle(color: Colors.grey.shade600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        /// Price and checkbox
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.price == 0 ? "Free" : "\$${item.price}",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (item.optional && onToggle != null) ...[
              const SizedBox(width: 8),
              Checkbox(
                value: selected,
                onChanged: (v) {
                  if (onToggle != null) onToggle!(v ?? false);
                },
                activeColor: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
