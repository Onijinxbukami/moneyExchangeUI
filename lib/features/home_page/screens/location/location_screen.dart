import 'package:flutter/material.dart';

class LocationForm extends StatefulWidget {
  const LocationForm({super.key});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final TextEditingController locationController = TextEditingController();
  final List<Map<String, String>> outlets = [
    {
      'name': 'Outlet 1',
      'address': '123 Main St, New York, NY',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 2',
      'address': '456 Park Ave, Los Angeles, CA',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 3',
      'address': '789 Broadway, San Francisco, CA',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 4',
      'address': '101 Oak St, Chicago, IL',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 5',
      'address': '202 Pine St, Miami, FL',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 6',
      'address': '303 Maple St, Dallas, TX',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 7',
      'address': '404 Elm St, Austin, TX',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 8',
      'address': '505 Birch St, Boston, MA',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 9',
      'address': '606 Cedar St, Denver, CO',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 10',
      'address': '707 Fir St, Seattle, WA',
      'rate': '1 USD = 1.7 SGD'
    },
  ];

  List<Map<String, String>> filteredOutlets = [];

  @override
  void initState() {
    super.initState();
    filteredOutlets = outlets.take(5).toList();
  }

  void filterOutlets(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOutlets = [];
      } else {
        filteredOutlets = outlets
            .where((outlet) =>
                outlet['name']!.toLowerCase().contains(query.toLowerCase()) ||
                outlet['address']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Padding xung quanh nội dung
      child: Column(
        children: [
          // Label text
          const Text(
            'Search address or postcode',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00274D),
            ),
          ),
          const SizedBox(height: 10),

          // TextField tìm kiếm
          TextField(
            controller: locationController,
            onChanged: filterOutlets,
            decoration: InputDecoration(
              labelText: 'Enter your text',
              hintText: 'Type something...',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(height: 20),


          Expanded(
            child: filteredOutlets.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredOutlets.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredOutlets[index]['name']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredOutlets[index]['address']!),
                            const SizedBox(height: 5),
                            Text(
                              filteredOutlets[index]['rate']!,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No results found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
