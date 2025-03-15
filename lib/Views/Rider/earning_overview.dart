import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EarningsOverviewPage extends StatelessWidget {
  // Original data (duplicate days included)
  final List<Map<String, dynamic>> rawData = [
    {"day": "Mon", "earnings": 120},
    {"day": "Tue", "earnings": 200},
    {"day": "Wed", "earnings": 150},
    {"day": "Thu", "earnings": 20},
    {"day": "Fri", "earnings": 220},
    {"day": "Sat", "earnings": 300},
    {"day": "Sun", "earnings": 250},
  ];

  EarningsOverviewPage({super.key});

  // Method to combine earnings for the same day
  List<Map<String, dynamic>> getProcessedData() {
    Map<String, int> combinedEarnings = {};

    for (var entry in rawData) {
      String day = entry["day"];
      int earnings = entry["earnings"];

      if (combinedEarnings.containsKey(day)) {
        combinedEarnings[day] = combinedEarnings[day]! + earnings;
      } else {
        combinedEarnings[day] = earnings;
      }
    }

    return combinedEarnings.entries
        .map((e) => {"day": e.key, "earnings": e.value})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> earningsData = getProcessedData();

    return Scaffold(
      backgroundColor: const Color(0xFF323d4f),
      appBar: AppBar(
        title: const Text(
          "Earnings Overview",
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        backgroundColor: const Color(0xFF323d4f),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Earnings Overview",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Weekly Earnings",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < earningsData.length) {
                              return Text(
                                earningsData[value.toInt()]["day"],
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return const Text("");
                          },
                          reservedSize: 22,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          earningsData.length,
                          (index) => FlSpot(index.toDouble(),
                              earningsData[index]["earnings"].toDouble()),
                        ),
                        isCurved: true,
                        color: const Color(0xFF323d4f),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text("Back",
                    style: TextStyle(color: Color(0xFF323d4f))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
