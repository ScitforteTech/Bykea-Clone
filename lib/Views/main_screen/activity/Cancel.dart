import 'package:flutter/material.dart';
import 'package:vroom_ride_app/components/Activity.dart';
import 'package:vroom_ride_app/data/activity.dart';

class Cancel extends StatelessWidget {
  const Cancel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: Canceldata.length,
        itemBuilder: (context, index) {
          return CancelCard(
            name: Canceldata[index]['name']!,
            car: Canceldata[index]['car']!,
            time: Canceldata[index]['time']!,
          );
        },
      ),
    );
  }
}
