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
    final details = meal.mealDetails.isNotEmpty ? meal.mealDetails.first : null;
    final bool isOptional = meal.optional == true;
    final bool effectiveSelected = !isOptional || isSelected;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: effectiveSelected ? Colors.lightBlue.shade50 : Colors.white,
        border: Border.all(
          color: isSelected ? (effectiveSelected ? Colors.blue.shade600 : Colors.grey.shade300) : Colors.lightBlue.shade50,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: isOptional ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 18,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      details?.cuisine != null
                          ? "Cuisine: ${details!.cuisine}"
                          : "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rs. ${meal.price}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOptional ? "Optional" : "Fixed",
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
        ),
      ),
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
              color: isOptional ? Color(0xFF00A63E) : Color(0xFFE6F8EB),
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
                    "${(activity.duration) ~/ 60} hours",
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
    final stay = accommodation.stayDetails.isNotEmpty
        ? accommodation.stayDetails.first
        : null;

    final bool isOptional = accommodation.optional == true;
    final bool effectiveSelected = !isOptional || isSelected;

    const purple = Color(0xFF9C27B0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: effectiveSelected ? Color(0xFFF8E9FF) : Colors.white,
        border: Border.all(
          color: isOptional ? (effectiveSelected ? purple : Colors.grey.shade300) : Color(0xFFF8E9FF),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: isOptional ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.hotel,
                size: 40,
                color: effectiveSelected
                    ? purple
                    : Colors.grey.shade400,
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay?.hotelName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (stay?.rating ?? 0).toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rs. ${accommodation.price}/night",
                    style: const TextStyle(
                      fontSize: 14,
                      color: purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOptional ? "Optional" : "Fixed",
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
        ),
      ),
    );
  }
}
