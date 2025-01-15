import 'package:flutter/material.dart';

import 'package:flutter_application_1/shared/widgets/numberic_field.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "GBP";
  String toCurrency = "USD";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1), // Thêm border
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

            _buildInputSection("You Send ", fromCurrency, (value) {
              setState(() {
                fromCurrency = value!;
              });
            }), // Input cho "From"
            const SizedBox(height: 20),
            _buildInputSection("Recipient gets", toCurrency, (value) {
              setState(() {
                toCurrency = value!;
              });
            }), // Input cho "To"
            const SizedBox(height: 40),
            _buildSendSendInfo(), // Hiển thị thông tin Exchange
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Send Pressed!")),
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
                  "Send", // Nội dung nút
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

  Widget _buildSendSendInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Exchange Rate", "1.37310",
            tooltip:
                "The Convert rate represents the rate of exchange you will receive when sending your money."),
        _buildInfoRow("Fees", "2.00 GBP"),

        _buildInfoRow("Recipient receives ", "549.24", isRecipient: true),
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
