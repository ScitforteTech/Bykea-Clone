import 'package:flutter/material.dart';

class Active extends StatelessWidget {
  const Active({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {'name': 'Nade', 'car': 'Mustang Shelby GT', 'time': 'Today at 09:20 am'},
      {
        'name': 'Ahmed',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 10:20 am'
      },
      {
        'name': 'Mohamed',
        'car': 'Mustang Shelby GT',
        'time': 'Tomorrow at 09:20 am'
      },
      {
        'name': 'Shrouk',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 09:20 am'
      },
      {'name': 'Nade', 'car': 'Mustang Shelby GT', 'time': 'Today at 09:20 am'},
      {
        'name': 'Ahmed',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 10:20 am'
      },
      {
        'name': 'Mohamed',
        'car': 'Mustang Shelby GT',
        'time': 'Tomorrow at 09:20 am'
      },
      {
        'name': 'Shrouk',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 09:20 am'
      },
      {'name': 'Nade', 'car': 'Mustang Shelby GT', 'time': 'Today at 09:20 am'},
      {
        'name': 'Ahmed',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 10:20 am'
      },
      {
        'name': 'Mohamed',
        'car': 'Mustang Shelby GT',
        'time': 'Tomorrow at 09:20 am'
      },
      {
        'name': 'Shrouk',
        'car': 'Mustang Shelby GT',
        'time': 'Today at 09:20 am'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]['name']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data[index]['car']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data[index]['time']!,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
