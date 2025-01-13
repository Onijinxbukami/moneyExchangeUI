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
                    const SnackBar(content: Text("Get Started Pressed!")),
                  );
                },
                child: const Text("Get Started"),
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
      padding: const EdgeInsets.all(8), // Add some padding inside the container
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.grey), // Add border around the container
        borderRadius:
            BorderRadius.circular(8), // Rounded corners for the border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use NumericField here for numeric input
                NumericField(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            items: const [
              DropdownMenuItem(value: "GBP", child: Text("GBP")),
              DropdownMenuItem(value: "USD", child: Text("USD")),
            ],
            onChanged: onChanged,
            value: selectedValue,
            underline: Container(),
          ),
        ],
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
        _buildInfoRow("You pay", "402.00 GBP"),
        _buildInfoRow("Recipient receives (Expected by July 6)", "549.24",
            isRecipient: true),
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
