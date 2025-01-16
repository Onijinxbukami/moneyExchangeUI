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
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double padding = isSmallScreen ? 12.0 : 16.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1), // Thêm border
          borderRadius: BorderRadius.circular(12), // Bo góc cho border
          color: Colors.white, // Màu nền cho container
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text(
                'Search address or postcode',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const SizedBox(height: 10), // Khoảng cách sau Label

            // TextField tìm kiếm
            TextField(
              controller: locationController,
              onChanged: filterOutlets, // Lọc kết quả khi người dùng nhập
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),

            const SizedBox(height: 20),

            // Danh sách các địa điểm gợi ý
            if (filteredOutlets.isNotEmpty)
              SizedBox(
                height: 250, // Giới hạn chiều cao danh sách gợi ý
                child: ListView.builder(
                  itemCount: filteredOutlets.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredOutlets[index]['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filteredOutlets[index]['address']!),
                          SizedBox(
                              height: 5), // Khoảng cách giữa address và tỷ giá
                          Text(
                            '${filteredOutlets[index]['rate']}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

           
          ],
        ),
      ),
    );
  }
}
