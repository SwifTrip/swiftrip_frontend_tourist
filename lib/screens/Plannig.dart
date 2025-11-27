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
  final meals =
      item.where((element) => element.type == 'MEAL').toList();
  final activities =
      item.where((element) => element.type == 'ACTIVITY').toList();
  final accommodations =
      item.where((element) => element.type == 'STAY').toList();

  final breakfastDetails =
      meals.where((meal) => meal.mealDetails[0].mealType.toLowerCase() == "breakfast").toList();
  final lunchDetails =
      meals.where((meal) => meal.mealDetails[0].mealType.toLowerCase() == "lunch").toList();
  final dinnerDetails =
      meals.where((meal) => meal.mealDetails[0].mealType.toLowerCase() == "dinner").toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // MEALS
      const Text(
        "Meals",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      if (breakfastDetails.isNotEmpty) ...[
        const SizedBox(height: 8),
        const Text(
          "Breakfast",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: breakfastDetails.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => MealItem(
            meal: breakfastDetails[index],
            isSelected: selectedMeals.contains(breakfastDetails[index].id),
            onTap: () {
              setState(() {
                final id = breakfastDetails[index].id;
                if (selectedMeals.contains(id)) {
                  selectedMeals.remove(id);
                } else {
                  selectedMeals.add(id);
                }
              });
            },
          ),
        ),
      ],

      if (lunchDetails.isNotEmpty) ...[
        const SizedBox(height: 8),
        const Text(
          "Lunch",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: lunchDetails.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => MealItem(
            meal: lunchDetails[index],
            isSelected: selectedMeals.contains(lunchDetails[index].id),
            onTap: () {
              setState(() {
                final id = lunchDetails[index].id;
                if (selectedMeals.contains(id)) {
                  selectedMeals.remove(id);
                } else {
                  selectedMeals.add(id);
                }
              });
            },
          ),
        ),
      ],

      if (dinnerDetails.isNotEmpty) ...[
        const SizedBox(height: 8),
        const Text(
          "Dinner",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: dinnerDetails.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => MealItem(
            meal: dinnerDetails[index],
            isSelected: selectedMeals.contains(dinnerDetails[index].id),
            onTap: () {
              setState(() {
                final id = dinnerDetails[index].id;
                if (selectedMeals.contains(id)) {
                  selectedMeals.remove(id);
                } else {
                  selectedMeals.add(id);
                }
              });
            },
          ),
        ),
      ],

      const SizedBox(height: 15),

      // ACTIVITIES
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Activities",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      const SizedBox(height: 8),

      Builder(
        builder: (context) {
          // fixed or already added => TOP
          final mainActivities = activities
              .where((e) =>
                  e.optional == false ||
                  selectedActivities.contains(e.id))
              .toList();

          // optional and not selected => BELOW as plus cards
          final addActivities = activities
              .where((e) =>
                  e.optional == true &&
                  !selectedActivities.contains(e.id))
              .toList();

          return Column(
            children: [
              // TOP: fixed + selected optionals (green)
              ListView.builder(
                itemCount: mainActivities.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final act = mainActivities[index];
                  return ActivityItem(
                    activity: act,
                    isSelected: selectedActivities.contains(act.id),
                    onTap: () {
                      setState(() {
                        if (act.optional) {
                          if (selectedActivities.contains(act.id)) {
                            selectedActivities.remove(act.id);
                          } else {
                            selectedActivities.add(act.id);
                          }
                        }
                      });
                    },
                  );
                },
              ),

              // BELOW: optional not selected (plus cards)
              if (addActivities.isNotEmpty) ...[
                const SizedBox(height: 8),
                ListView.builder(
                  itemCount: addActivities.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final act = addActivities[index];
                    return ActivityItem(
                      activity: act,
                      isSelected: false, // force plus UI
                      onTap: () {
                        setState(() {
                          selectedActivities.add(act.id);
                        });
                      },
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),

      // ACCOMMODATIONS
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
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
        itemBuilder: (context, index) {
          final stay = accommodations[index];
          return AccommodationItem(
            accommodation: stay,
            isSelected: selectedAccommodations.contains(stay.id),
            onTap: () {
              setState(() {
                if (selectedAccommodations.contains(stay.id)) {
                  selectedAccommodations.remove(stay.id);
                } else {
                  selectedAccommodations.add(stay.id);
                }
              });
            },
          );
        },
      ),
    ],
  );
}

}