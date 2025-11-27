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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: meal.mealDetails.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
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
    final bool isOptional = activity.optional == true;

    // plus card for optional & not selected
    if (isOptional && !isSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // green card (fixed or selected optional) with label under price
    final String labelText = isOptional ? "Optional" : "Fixed";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F8EB),
            border: Border.all(
              color: const Color(0xFF00A63E),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: isOptional ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D7A35),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rs. ${activity.price}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0D7A35),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            labelText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(activity.duration ?? 0) ~/ 60} hours",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0D7A35),
                    ),
                  ),
                ],
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
    return Column(
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
