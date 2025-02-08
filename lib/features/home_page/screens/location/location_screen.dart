import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

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
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                tr('discover_outlets'), 
                style: const TextStyle(
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
              placeholder: tr('search_placeholder'), 
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
                    : Center(
                        child: Text(
                          tr('no_results'), 
                          style: const TextStyle(
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
