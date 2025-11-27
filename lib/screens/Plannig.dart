import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:swift_trip_app/widgets/itineraryItems.dart';

class PlanningScreen extends StatefulWidget {
  final TourResponse tourResponse;
  PlanningScreen({required this.tourResponse});
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  List<int> selectedMeals = [];
  List<int> selectedActivities = [];
  List<int> selectedAccommodations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentStep: 2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Plan Your Journey", style: TextStyle(fontSize: 18)),
            ),
            Column(
              children: [
                buildHeader(
                  widget.tourResponse.basePackage.title,
                  widget.tourResponse.basePackage.description,
                  widget.tourResponse.basePackage.category,
                  widget.tourResponse.basePackage.basePrice.toDouble(),
                  widget.tourResponse.basePackage.toLocation,
                  widget.tourResponse.basePackage.fromLocation,
                  widget.tourResponse.basePackage.maxGroupSize ?? 0,
                ),
                buildDay(widget.tourResponse.basePackage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDay(BasePackage basePackage) {
    final dateFormat = DateFormat('dd MMM, hh:mm a');
    return ListView.builder(
      shrinkWrap: true,
      itemCount: basePackage.itineraries.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basePackage.itineraries[index].title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    "Start time  ${basePackage.itineraries[index].startTime != null ? dateFormat.format(basePackage.itineraries[index].startTime!) : ''} - End time"
                    " ${basePackage.itineraries[index].endTime != null ? dateFormat.format(basePackage.itineraries[index].endTime!) : ''}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  buildItinerartyItem(
                    basePackage.itineraries[index].itineraryItems,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(
    String title,
    String description,
    String category,
    double price,
    String to,
    String from,
    int groupSize,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 16),

            // Category
            Row(
              children: [
                const Icon(Icons.category, size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Text(category, style: const TextStyle(fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),

            // Group Size
            Row(
              children: [
                const Icon(Icons.group, size: 18, color: Colors.purple),
                const SizedBox(width: 6),
                Text(
                  "Group Size: $groupSize",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Price
            Row(
              children: [
                const Icon(Icons.attach_money, size: 18, color: Colors.green),
                const SizedBox(width: 6),
                Text("PKR $price", style: const TextStyle(fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),

            // Route
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.red),
                const SizedBox(width: 6),
                Text("$from  →  $to", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItinerartyItem(List<ItineraryItem> item) {
    final meals = item.where((element) => element.type == 'MEAL').toList();
    final activities = item
        .where((element) => element.type == 'ACTIVITY')
        .toList();
    final accommodations = item
        .where((element) => element.type == 'STAY')
        .toList();
    final breakfastDetails = meals.where((meal) => meal.name == "Breakfast").toList();
    final lunchDetails = meals.where((meal) => meal.name == "Lunch").toList();
    final dinnerDetails = meals.where((meal) => meal.name == "Dinner").toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meals",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (breakfastDetails.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Breakfast",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: breakfastDetails.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => (MealItem(
              meal: breakfastDetails[index],
              isSelected: selectedMeals.contains(breakfastDetails[index].id),
              onTap: () {
                setState(() {
                  if (selectedMeals.contains(breakfastDetails[index].id)) {
                    selectedMeals.remove(breakfastDetails[index].id);
                  } else {
                    selectedMeals.add(breakfastDetails[index].id);
                  }
                });
              },
            )),
          ),
        ],
        if (lunchDetails.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Lunch",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: lunchDetails.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => (MealItem(
              meal: lunchDetails[index],
              isSelected: selectedMeals.contains(lunchDetails[index].id),
              onTap: () {
                setState(() {
                  if (selectedMeals.contains(lunchDetails[index].id)) {
                    selectedMeals.remove(lunchDetails[index].id);
                  } else {
                    selectedMeals.add(lunchDetails[index].id);
                  }
                });
              },
            )),
          ),
        ],
        if (dinnerDetails.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Dinner",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: dinnerDetails.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => (MealItem(
              meal: dinnerDetails[index],
              isSelected: selectedMeals.contains(dinnerDetails[index].id),
              onTap: () {
                setState(() {
                  if (selectedMeals.contains(dinnerDetails[index].id)) {
                    selectedMeals.remove(dinnerDetails[index].id);
                  } else {
                    selectedMeals.add(dinnerDetails[index].id);
                  }
                });
              },
            )),
          ),
        ],
        const SizedBox(height:  15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              "Activities",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: activities.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => (Column(
            children: [
              if (activities[index].type == 'ACTIVITY')
                ActivityItem(
                  activity: activities[index],
                  isSelected: selectedActivities.contains(activities[index].id),
                  onTap: () {
                    setState(() {
                      if (selectedActivities.contains(activities[index].id)) {
                        selectedActivities.remove(activities[index].id);
                      } else {
                        selectedActivities.add(activities[index].id);
                      }
                    });
                  },
                ),
            ],
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Accommodations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: accommodations.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => (Column(
            children: [
              if (accommodations[index].type == 'STAY')
                AccommodationItem(
                  accommodation: accommodations[index],
                  isSelected: selectedAccommodations.contains(
                    accommodations[index].id,
                  ),
                  onTap: () {
                    setState(() {
                      if (selectedAccommodations.contains(
                        accommodations[index].id,
                      )) {
                        selectedAccommodations.remove(accommodations[index].id);
                      } else {
                        selectedAccommodations.add(accommodations[index].id);
                      }
                    });
                  },
                ),
            ],
          )),
        ),
      ],
    );
  }
}