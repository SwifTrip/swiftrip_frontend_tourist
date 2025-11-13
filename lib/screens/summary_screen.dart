import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Tour Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Review your customized tour package',
                style: TextStyle(
                  fontSize: 16,
                  color: ,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildItinerary(),
            const SizedBox(height: 20),
            _buildCostBreakdown(),
          ],
        ),
      ),
      bottomNavigationBar: ,
    );
  }
}