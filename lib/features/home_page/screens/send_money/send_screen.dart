import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    final double padding = isSmallScreen ? 12.0 : 24.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressStepper(
              steps: const [
                "Amount",
                "You",
                "Recipient",
                "Review",
                "Pay",
              ],
              currentStep: 0,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: isSmallScreen ? 8 : 10,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // Numeric Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 6 : 8,
              ),
              child: NumericField(),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // "You Send" Input Section
            _buildInputSection("You Send", fromCurrency, (value) {
              setState(() {
                fromCurrency = value!;
              });
            }, isSmallScreen, fontSize),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // "Recipient gets" Input Section
            _buildInputSection("Recipient gets", toCurrency, (value) {
              setState(() {
                toCurrency = value!;
              });
            }, isSmallScreen, fontSize),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // Send Money Info
            _buildSendInfo(isSmallScreen, fontSize),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // "Send" Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.exchangeDetails);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Send Pressed!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6200EE),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 40 : 80,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                minimumSize: Size(double.infinity, isSmallScreen ? 48 : 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Send",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(
    String label,
    String selectedValue,
    ValueChanged<String?> onChanged,
    bool isSmallScreen,
    double fontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 12,
            vertical: isSmallScreen ? 4 : 8,
          ),
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
        ),
      ],
    );
  }

  Widget _buildSendInfo(bool isSmallScreen, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Exchange Rate",
          "1.37310",
          tooltip: "The exchange rate represents the rate of exchange you will receive when sending your money.",
          fontSize: fontSize,
        ),
        _buildInfoRow("Fees", "2.00 GBP", fontSize: fontSize),
        _buildInfoRow("Recipient receives", "549.24",
            isRecipient: true, fontSize: fontSize),
      ],
    );
  }

  Widget _buildInfoRow(
    String title,
    String value, {
    String? tooltip,
    bool isRecipient = false,
    required double fontSize,
  }) {
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
                  fontSize: fontSize,
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
          Text(
            value,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
