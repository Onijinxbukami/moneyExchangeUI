import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/widgets/numberic_field.dart';

class ChartForm extends StatefulWidget {
  const ChartForm({super.key});

  @override
  State<ChartForm> createState() => _ChartFormState();
}

class _ChartFormState extends State<ChartForm> {
  String fromCurrency = "GBP";
  String toCurrency = "USD";

  @override
  Widget build(BuildContext context) {
    return Center(
      // Đặt widget vào giữa màn hình
      child: Container(
        padding: const EdgeInsets.all(16), // Padding cho toàn bộ widget
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1), // Thêm border
          borderRadius: BorderRadius.circular(12), // Bo góc cho border
          color: Colors.white, // Màu nền cho container
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'From',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold), // Định dạng chữ "From"
            ),
            const SizedBox(height: 8),
            _buildInputSection("From", fromCurrency, (value) {
              setState(() {
                fromCurrency = value!;
              });
            }), // Input cho "From"
            const SizedBox(height: 20),
            const Text(
              'To',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold), // Định dạng chữ "From"
            ),
            const SizedBox(height: 8),
            _buildInputSection("To", toCurrency, (value) {
              setState(() {
                toCurrency = value!;
              });
            }), // Input cho "To"
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("View Chart Pressed!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4743C9), // Màu nền của nút
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80, // Padding ngang
                    vertical: 16, // Padding dọc
                  ),
                  minimumSize: const Size(double.infinity,
                      56), // Chiều rộng tự động, chiều cao tối thiểu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Bo góc của nút
                  ),
                ),
                child: const Text(
                  "View Chart", // Nội dung nút
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ
                    fontWeight: FontWeight.bold, // Đậm chữ
                    color: Colors.white, // Màu chữ trắng
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Input section with text field and dropdown
  Widget _buildInputSection(
      String label, String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4), // Thêm padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Thêm border quanh container
        borderRadius: BorderRadius.circular(8), // Bo góc cho border
      ),
      child: DropdownButton<String>(
        isExpanded: true, // Cho phép DropdownButton chiếm toàn bộ chiều rộng
        items: const [
          DropdownMenuItem(value: "GBP", child: Text("GBP")),
          DropdownMenuItem(value: "USD", child: Text("USD")),
        ],
        onChanged: onChanged, // Thay đổi giá trị khi chọn
        value: selectedValue,
        underline: Container(), // Xóa đường gạch chân mặc định
        icon: const Icon(Icons.arrow_drop_down), // Mũi tên tùy chỉnh
      ),
    );
  }


}
