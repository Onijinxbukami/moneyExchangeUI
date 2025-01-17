import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';


class HomepageAddressPage extends StatefulWidget {
  const HomepageAddressPage({super.key});

  @override
  _HomepageAddressPageState createState() => _HomepageAddressPageState();
}

class _HomepageAddressPageState extends State<HomepageAddressPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController locationController = TextEditingController();
  final List<String> locations = [
    'New York',
    'Los Angeles',
    'San Francisco',
    'Chicago',
    'Miami',
    'Dallas',
    'Austin',
    'Boston',
    'Denver',
    'Seattle'
  ];
  List<String> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    filteredLocations = locations.take(5).toList();
  }

  void filterLocations(String query) {
    setState(() {
      // Nếu ô tìm kiếm trống, không hiển thị gì cả
      if (query.isEmpty) {
        filteredLocations = [];
      } else {
        filteredLocations = locations
            .where((location) =>
                location.toLowerCase().contains(query.toLowerCase()))
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6610F2),
        leading: isSmallScreen
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
      ),

      body: Row(
        children: [


          Expanded(
            child: Column(
              children: [

                _buildContent(fontSize, padding), // Truyền fontSize và padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget midHeader(double fontSize, double padding) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Enter Your Address',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'You may need to provide proof of this',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Search address or postcode',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: locationController,
              onChanged: filterLocations, // Lọc kết quả khi người dùng nhập
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
            // Danh sách địa điểm gợi ý
            if (filteredLocations.isNotEmpty)
              ListView.builder(
                shrinkWrap: true, // Không cần chiếm toàn bộ chiều cao
                itemCount:
                    filteredLocations.length > 5 ? 5 : filteredLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredLocations[index]),
                    onTap: () {
                      // Xử lý khi người dùng chọn một địa điểm
                      print('Selected: ${filteredLocations[index]}');
                    },
                  );
                },
              ),

            const SizedBox(height: 40), // Khoảng cách giữa ListView và nút
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Hành động khi bấm nút Continue
                  debugPrint('Continue pressed');
                  Navigator.pushNamed(context, Routes.userDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE), // Màu tím nổi bật
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 30), // Padding nhỏ hơn
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo tròn góc nút
                  ),
                  elevation: 6, // Hiệu ứng đổ bóng
                  // ignore: deprecated_member_use
                  shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng nhẹ
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(double fontSize, double padding) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          midHeader(fontSize, padding),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
