import 'package:flutter/material.dart';
import 'package:swift_trip_app/screens/Agency.dart';
import 'package:swift_trip_app/services/search_service.dart';
import 'package:swift_trip_app/services/token_service.dart';
import 'package:swift_trip_app/widgets/custom_app_bar.dart';
import 'package:swift_trip_app/widgets/custom_bottom_bar.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  String? _storedToken;
  bool _hasToken = false;

  final List<String> cities = [
    // Punjab
    "Sargodha",
    "Lahore",
    "Faisalabad",
    "Rawalpindi",
    "Gujranwala",
    "Multan",
    "Sialkot",
    "Bahawalpur",
    "Sahiwal", "Jhang", "Dera Ghazi Khan", "Sheikhupura", "Rahim Yar Khan",
    // Sindh
    "Karachi",
    "Hyderabad",
    "Sukkur",
    "Larkana",
    "Nawabshah",
    "Mirpurkhas",
    "Khairpur",
    // Khyber Pakhtunkhwa (KP)
    "Peshawar",
    "Mardan",
    "Abbottabad",
    "Swat",
    "Kohat",
    "Dera Ismail Khan",
    "Charsadda",
    "Chitral",
    "Naran",
    // Balochistan
    "Quetta", "Gwadar", "Turbat", "Zhob", "Khuzdar", "Sibi",
    // Islamabad Capital Territory
    "Islamabad",
    // Gilgit-Baltistan
    "Gilgit", "Skardu", "Hunza",
    // Azad Jammu & Kashmir
    "Muzaffarabad", "Mirpur", "Kotli",
  ];

  late String fromCity = cities[0];
  late String toCity = cities[1];

  late TextEditingController minBudget;
  late TextEditingController maxBudget;

  @override
  void initState() {
    super.initState();
    minBudget = TextEditingController();
    maxBudget = TextEditingController();
    _checkStoredData();
  }

  Future<void> _checkStoredData() async {
    final token = await TokenService.getToken();
    final hasToken = await TokenService.hasToken();

    setState(() {
      _storedToken = token;
      _hasToken = hasToken;
    });

    // Show token info in a dialog
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Local Storage Debug Info'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Has Token: ${_hasToken ? "Yes ✓" : "No ✗"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _hasToken ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Token Value:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  SelectableText(
                    _storedToken ?? 'No token found',
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                  SizedBox(height: 10),
                  if (_storedToken != null) ...[
                    Text('Token Length: ${_storedToken!.length} characters'),
                    SizedBox(height: 5),
                    Text(
                      'First 20 chars: ${_storedToken!.substring(0, _storedToken!.length > 20 ? 20 : _storedToken!.length)}...',
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    minBudget.dispose();
    maxBudget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentStep: 0),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _hasToken ? Icons.check_circle : Icons.error,
                      color: _hasToken ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _hasToken ? "Authenticated" : "Not Authenticated",
                      style: TextStyle(
                        fontSize: 14,
                        color: _hasToken ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Select Your Journey",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 15),
                child: Text(
                  "Choose your departure and arrival cities",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _labelbuild("Departure City"),
                      _dropdownbuild("Departure City"),
                      _labelbuild("Arrival City"),
                      _dropdownbuild("Arrival City"),
                      _labelbuild("Minimum Budget"),
                      _budgetBuild("Minimum Budget", minBudget),
                      _labelbuild("Maximum Budget"),
                      _budgetBuild("Maximum Budget", maxBudget),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      int min = int.tryParse(minBudget.text) ?? 0;
                      int max = int.tryParse(maxBudget.text) ?? 999999;

                      final service = TourService();
                      final results = await service.searchAgencies(
                        fromCity: fromCity,
                        toCity: toCity,
                        minBudget: min,
                        maxBudget: max,
                      );

                      // Navigate to screen showing results
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgencyScreen(
                            agencies: results,
                            budget: min,
                            destination: toCity,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Search failed: $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 15,
                    ),
                    child: Text("Continue", style: TextStyle()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }

  Widget _labelbuild(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // Icon(
          //   Icons.place,
          //   color: title == "Departure City" ? Colors.blue : Colors.green,
          // ),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _dropdownbuild(String city) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          hintText: city,
        ),
        initialValue: city == "Arrival City" ? toCity : fromCity,
        items: cities.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (city == "Arrival City") {
              toCity = value.toString();
            } else {
              fromCity = value.toString();
            }
          });
        },
      ),
    );
  }

  Widget _budgetBuild(String title, TextEditingController controllerName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          hintText: title,
        ),
        controller: controllerName,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
