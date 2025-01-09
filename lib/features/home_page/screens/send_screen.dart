import 'package:flutter/material.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({Key? key}) : super(key: key);

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "GBP"; 
  String toCurrency = "USD";   

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildInputSection("You Send", fromCurrency, (value) {
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
        _buildSendSendInfo(), // Hiển thị thông tin SendSend
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Hành động khi nhấn nút "Get Started"
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Get Started Pressed!")),
            );
          },
          child: const Text("Get Started"),
        ),
      ],
    );
  }

  Widget _buildInputSection(String label, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                ),
              ),
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
