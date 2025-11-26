import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/agency_response_model.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class PlanningScreen extends StatefulWidget {
  final TourResponse tourResponse;
  PlanningScreen({required this.tourResponse});
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int selectedStayDetailsIndex = -1;
  bool isSelected = false;
  List<ItineraryItem> selectedStayDetails = [];
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Accommodations",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("not optional", style: TextStyle(color: Colors.grey),),
          ],
        ),
        const SizedBox(height: 8),
        Text("Select an accommodation:", style: TextStyle(fontSize: 14)),
        ListView.builder(
          itemCount: item.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => (Column(
            children: [
              if (item[index].type == 'STAY') buildAccomadation(item[index]),
            ],
          )),
        ),
        Text("Activities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: item.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => (Column(
            children: [
              if (item[index].type == 'ACTIVITY') buildActivity(item[index]),
            ],
          )),
        ),
      ],
    );
  }

   Widget buildActivity(ItineraryItem activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: activity.stayDetails.length,
          physics: const NeverScrollableScrollPhysics(),

          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selectedStayDetailsIndex == index
                  ? Color.fromARGB(255, 208, 250, 222)
                  : Colors.white,
              border: Border.all(
                color: selectedStayDetailsIndex == index
                    ?  Color(0xFF00A63E)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            child: InkWell(
              onTap: () {
                setState(() {
                  if (selectedStayDetailsIndex == index) {
                    selectedStayDetailsIndex = -1;
                  } else {
                    selectedStayDetailsIndex = index;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.stayDetails[index].hotelName ?? 'N/A',
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
                      "Rating: ${activity.stayDetails[index].rating}",
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

  Widget buildAccomadation(ItineraryItem activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: activity.stayDetails.length,
          physics: const NeverScrollableScrollPhysics(),

          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selectedStayDetailsIndex == index
                  ? Color.fromARGB(255, 208, 250, 222)
                  : Colors.white,
              border: Border.all(
                color: selectedStayDetailsIndex == index
                    ?  Color(0xFF00A63E)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            child: InkWell(
              onTap: () {
                setState(() {
                  if (selectedStayDetailsIndex == index) {
                    selectedStayDetailsIndex = -1;
                  } else {
                    selectedStayDetailsIndex = index;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.stayDetails[index].hotelName ?? 'N/A',
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
                      "Rating: ${activity.stayDetails[index].rating}",
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
