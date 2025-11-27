import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';

class MealItem extends StatelessWidget {
  final ItineraryItem meal;
  final bool isSelected;
  final VoidCallback onTap;

  const MealItem({
    Key? key,
    required this.meal,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // paste your buildMeal UI here, but:
    // - use isSelected instead of selectedMeals.contains
    // - call onTap() instead of setState(...)
    // example:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: meal.mealDetails.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: meal.optional
                  ? (isSelected
                        ? const Color.fromARGB(255, 208, 250, 222)
                        : Colors.white)
                  : const Color.fromARGB(255, 208, 250, 222),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meal.mealDetails[index].mealType,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rs ${meal.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Cuisine: ${meal.mealDetails[index].cuisine}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  final ItineraryItem activity;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityItem({
    Key? key,
    required this.activity,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // paste your buildActivity UI, use isSelected + onTap;
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 208, 250, 222)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rs ${activity.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      activity.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AccommodationItem extends StatelessWidget {
  final ItineraryItem accommodation;
  final bool isSelected;
  final VoidCallback onTap;

  const AccommodationItem({
    Key? key,
    required this.accommodation,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // paste your buildAccomadation UI, use isSelected + onTap;
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: accommodation.stayDetails.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 208, 250, 222)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00A63E)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          accommodation.stayDetails[index].hotelName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rs ${accommodation.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Rating: ${accommodation.stayDetails[index].rating}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
