import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16), // Padding xung quanh nội dung
      child: Column(
        children: [
          // Số tiền người dùng nhập
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NumericField(),
          ),
          const SizedBox(height: 20),

          // Input "You Send"
          _buildInputSection("You Send ", fromCurrency, (value) {
            setState(() {
              fromCurrency = value!;
            });
          }),
          const SizedBox(height: 20),

          // Input "Recipient gets"
          _buildInputSection("Recipient gets", toCurrency, (value) {
            setState(() {
              toCurrency = value!;
            });
          }),
          const SizedBox(height: 20),

          // Thông tin gửi tiền
          _buildSendSendInfo(),
          const SizedBox(height: 20),

          // Nút "Send"
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.exchangeDetails);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Send Pressed!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4743C9),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              "Send",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(
      String label, String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: "GBP", child: Text("GBP")),
          DropdownMenuItem(value: "USD", child: Text("USD")),
        ],
        onChanged: onChanged,
        value: selectedValue,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down),
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
        _buildInfoRow("Recipient receives", "549.24", isRecipient: true),
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
