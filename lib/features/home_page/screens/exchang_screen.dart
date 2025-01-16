import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/widgets/numberic_field.dart';

class ExchangeForm extends StatefulWidget {
  const ExchangeForm({super.key});

  @override
  State<ExchangeForm> createState() => _ExchangeFormState();
}

class _ExchangeFormState extends State<ExchangeForm> {
  String fromCurrency = "GBP"; // Giá trị mặc định cho dropdown "From"
  String toCurrency = "USD"; // Giá trị mặc định cho dropdown "To"

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1), // Thêm border
          borderRadius: BorderRadius.circular(12), // Bo góc cho border
          color: Colors.white, // Màu nền cho container
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.black, width: 1), // Viền màu xám
                borderRadius: BorderRadius.circular(12), // Bo góc
                color: Colors.white, // Nền màu trắng
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8), // Thêm padding bên trong
              child: NumericField(),
            ),

            const SizedBox(height: 40),
            _buildInputSection("From", fromCurrency, (value) {
              setState(() {
                fromCurrency = value!;
              });
            }), // Input cho "From"
            const SizedBox(height: 20),
            _buildInputSection("To", toCurrency, (value) {
              setState(() {
                toCurrency = value!;
              });
            }), // Input cho "To"
            const SizedBox(height: 40),
            _buildExchangeInfo(), // Hiển thị thông tin Exchange
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Convert Pressed!")),
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
                  "Convert", // Nội dung nút
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

Widget _buildInputSection(
    String label, String selectedValue, ValueChanged<String?> onChanged) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Thêm padding
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



  Widget _buildExchangeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Exchange Rate", "2,000"),

        _buildInfoRow("You get", "402.00 GBP"),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value,
      {String? tooltip, bool isRecipient = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isRecipient ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (tooltip != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: tooltip,
                  child: const Icon(Icons.info_outline, size: 16),
                ),
              ],
            ],
          ),
          Text(value),
        ],
      ),
    );
  }
}
