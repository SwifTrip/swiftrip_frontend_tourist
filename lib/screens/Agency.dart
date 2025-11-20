import 'package:flutter/material.dart';
import 'package:swift_trip_app/models/Agency.dart';
import 'package:swift_trip_app/screens/Plannig.dart';
import 'package:swift_trip_app/services/get_packages.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:swift_trip_app/widgets/custom_bottom_bar.dart';

class AgencyScreen extends StatefulWidget {
  final int budget;
  final String destination;

  final List<Agency> agencies;
  const AgencyScreen({
    super.key,
    required this.agencies,
    required this.budget,
    required this.destination,
  });
  @override
  _AgencyScreenState createState() => _AgencyScreenState();
}

class _AgencyScreenState extends State<AgencyScreen> {
  late int agencyId = 0;
  late String category = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentStep: 1),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Choose Your Travel Partner",
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    "Select from our trusted travel agencies",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                ListView.builder(
                  itemCount: widget.agencies.length,
                  itemBuilder: (context, index) {
                    final agency = widget.agencies[index];
                    return buildAgencyCard(
                      agency.companyId,
                      agency.companyName,
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back, color: Colors.black),
                            Text("Back", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final service = PackageService();
                          final result = await service.getPackages(
                            agencyId: agencyId,
                            toCity: widget.destination,
                            minBudget: widget.budget,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PlanningScreen(tourResponse: result);
                              },
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Search failed: $e")),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }

  Widget buildAgencyCard(int agencyId, String agencyName) {
    bool selected = this.agencyId == agencyId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: selected ? const Color(0xffEFF6FF) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? Colors.blueAccent : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.add_a_photo, size: 50, color: Colors.brown),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(agencyName),
                    ),
                  ],
                ),
                Text("⭐ 4.8 (200 reviews)"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 5,
                      ),
                      shrinkWrap: true,
                      children: [
                        Card(child: Center(child: Text("Mountain Tours"))),
                        Card(child: Center(child: Text("Adventure Travels"))),
                        Card(child: Center(child: Text("Photography"))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              this.agencyId = agencyId;
            });
          },
        ),
      ),
    );
  }
}
