import 'package:flutter/cupertino.dart';
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
      'address': '303 Elm St, Houston, TX',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 7',
      'address': '404 Maple St, Phoenix, AZ',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 8',
      'address': '505 Cedar St, Philadelphia, PA',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 9',
      'address': '606 Birch St, San Antonio, TX',
      'rate': '1 USD = 1.7 SGD'
    },
    {
      'name': 'Outlet 10',
      'address': '707 Walnut St, San Diego, CA',
      'rate': '1 USD = 1.7 SGD'
    }
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // Label text
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Discover outlets near you ✨',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),

            // Search field
            CupertinoSearchTextField(
              controller: locationController,
              onChanged: filterOutlets,
              placeholder: "Enter your location or ZIP code 📍",
              style: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            ),
            const SizedBox(height: 16),

            // List results
            Expanded(
              child: CupertinoScrollbar(
                child: filteredOutlets.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredOutlets.length,
                        itemBuilder: (context, index) {
                          return CupertinoListTile(
                            title: Text(
                              filteredOutlets[index]['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.label,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredOutlets[index]['address']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  filteredOutlets[index]['rate']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(
                              fontSize: 16, color: CupertinoColors.systemGrey),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
