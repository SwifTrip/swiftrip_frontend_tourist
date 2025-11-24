import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';

class PlanningScreen extends StatefulWidget {
  final TourResponse tourResponse;
  PlanningScreen({required this.tourResponse});
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int selectedIndex = 0;
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return buildDay(widget.tourResponse.basePackage);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDay(BasePackage basePackage) {
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
                    "Day ${index + 1} ${basePackage.itineraries[index].title}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    basePackage.itineraries[index].description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 15),

                   Text(
                    "Start time  ${basePackage.itineraries[index].startTime} - End time  ${basePackage.itineraries[index].endTime}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.close, color: Colors.orange, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Meals: Breakfast",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Activities",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildActivity("Shangrila Lake Visit", "3 hours", "Rs. 5,000"),
                  buildActivity("Mountain Hiking", "5 hours", "Rs. 6,000"),
                  const SizedBox(height: 10),
                  Text(
                    "Add Activities",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Cultural Village Visit"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "Accommodation",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
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

  static Widget buildActivity(String title, String duration, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(duration),
        trailing: Text(
          price,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
