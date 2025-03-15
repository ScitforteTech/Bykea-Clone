
  import 'package:flutter/material.dart';

class Activity {
  Widget _buildInfoSectionCancel(String name, String car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          car,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSectionCancel(    String time) {
    return Text(
      time,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}
