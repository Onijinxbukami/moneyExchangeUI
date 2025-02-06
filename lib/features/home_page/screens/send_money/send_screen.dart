import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "GBP";
  String toCurrency = "USD";
  final TextEditingController _numericController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? _numericError;
  String selectedOutlet = "Outlet 1";
  String exchangeRate = "1.37310";
  Map<String, String> outletExchangeRates = {
    "Outlet 1": "1.37310",
    "Outlet 2": "1.25000",
    "Outlet 3": "1.45000",
  };

  final Map<String, String> flagUrls = {
    "GBP": "https://flagcdn.com/w40/gb.png",
    "USD": "https://flagcdn.com/w40/us.png",
  };
  DropdownMenuItem<String> _buildDropdownItem(String currency) {
    return DropdownMenuItem(
      value: currency,
      child: Row(
        children: [
          Image.network(flagUrls[currency]!,
              width: 24, height: 16, fit: BoxFit.cover),
          const SizedBox(width: 8),
          Text(currency, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Method to handle outlet change
  void _onOutletChanged(String? value) {
    setState(() {
      selectedOutlet = value!;
      exchangeRate = outletExchangeRates[selectedOutlet]!;
    });
  }

  void _validateNumeric() {
    final input = _numericController.text;

    // Check if the input contains only numbers (no letters or special characters)
    if (input.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(input)) {
      setState(() {
        _numericError = "Only numbers are allowed!";
      });
    } else {
      setState(() {
        _numericError = null; // Clear error if the input is valid
      });
    }
  }

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
                "Sender",
                "Recipient",
                "Review",
                "Success",
              ],
              currentStep: 0,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: isSmallScreen ? 8 : 10,
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            _buildInputSection(
              "Select Outlet",
              selectedOutlet,
              _onOutletChanged,
              isSmallScreen,
              fontSize,
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            // Numeric Field
            _buildCurrencyInputField(
              "You Send",
              fromCurrency,
              (value) {
                setState(() {
                  fromCurrency = value!;
                  toCurrency = (value == "USD") ? "GBP" : "USD";
                });
              },
              isSmallScreen,
              _numericController,
              isSender: true, // Quan trọng để xác định trường gửi tiền
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            _buildCurrencyInputField(
              "Recipient gets",
              toCurrency,
              (value) {
                setState(() {
                  toCurrency = value!;
                  fromCurrency = (value == "USD") ? "GBP" : "USD";
                });
              },
              isSmallScreen,
              _numericController,
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            // Send Money Info
            _buildSendInfo(isSmallScreen, fontSize),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // "Send" Button
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      height: 30), // Khoảng cách giữa dropdown và nút Continue
                  Center(
                      child: ElevatedButton(
                    onPressed: () {
                      debugPrint('Continue pressed');
                      Navigator.pushNamed(context, Routes.userDetails);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Continue Pressed!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6200EE),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width < 600 ? 40 : 80,
                        vertical:
                            MediaQuery.of(context).size.width < 600 ? 12 : 16,
                      ),
                      minimumSize: Size(
                        double.infinity,
                        MediaQuery.of(context).size.width < 600 ? 48 : 56,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 16
                                : 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
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
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 12,
            vertical: isSmallScreen ? 4 : 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
              isDense: true,
            ),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: "Outlet 1", child: Text("Outlet 1")),
              DropdownMenuItem(value: "Outlet 2", child: Text("Outlet 2")),
              DropdownMenuItem(value: "Outlet 3", child: Text("Outlet 3")),
            ],
            onChanged: onChanged,
            value: selectedValue,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyInputField(
      String label,
      String selectedValue,
      ValueChanged<String?> onChanged,
      bool isSmallScreen,
      TextEditingController controller,
      {bool isSender = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              DropdownButton<String>(
                value: selectedValue,
                items: [
                  _buildDropdownItem("GBP"),
                  _buildDropdownItem("USD"),
                ],
                onChanged: (value) {
                  setState(() {
                    if (isSender) {
                      fromCurrency = value!;
                      toCurrency = (value == "USD") ? "GBP" : "USD";
                    } else {
                      toCurrency = value!;
                      fromCurrency = (value == "USD") ? "GBP" : "USD";
                    }
                  });
                },
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _validateNumeric(),
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    errorText: _numericError,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
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
          exchangeRate,
          tooltip:
              "The exchange rate represents the rate of exchange you will receive when sending your money.",
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
