import 'package:flutter/material.dart';

class LocationForm extends StatefulWidget {
  const LocationForm({Key? key}) : super(key: key);

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1), // Thêm border
          borderRadius: BorderRadius.circular(12),          // Bo góc cho border
          color: Colors.white,                              // Màu nền cho container
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian tối thiểu
          children: [
            // TextField tìm kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                  hintText: 'Type to search...',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)), // Bo góc cho TextField
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Khoảng cách giữa TextField và bản đồ

            // Google Map
SizedBox(
              height: 300, // Chiều cao cố định cho box
              child: Center(
                child: Text(
                  "Map here",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
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


