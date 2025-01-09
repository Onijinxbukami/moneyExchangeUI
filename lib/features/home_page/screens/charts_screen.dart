import 'package:flutter/material.dart';

class ChartForm extends StatefulWidget {
  const ChartForm({Key? key}) : super(key: key);

  @override
  State<ChartForm> createState() => _ChartFormState();
}

class _ChartFormState extends State<ChartForm> {
  String fromCurrency = "GBP"; 
  String toCurrency = "USD";   

  @override
  Widget build(BuildContext context) {
    return Center(  // Đặt widget vào giữa màn hình
      child: Container(
        padding: const EdgeInsets.all(16),  // Padding cho toàn bộ widget
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),  // Thêm border
          borderRadius: BorderRadius.circular(12),  // Bo góc cho border
          color: Colors.white,  // Màu nền cho container
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            _buildTopArea(), // Hiển thị thông tin SendSend
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Input section with text field and dropdown
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
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            items: const [
              DropdownMenuItem(value: "GBP", child: Text("GBP")),
              DropdownMenuItem(value: "USD", child: Text("USD")),
            ],
            onChanged: onChanged,
            value: selectedValue,
            underline: Container(),
            isExpanded: false,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            dropdownColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  // Top area with chart and exchange rate information
  Widget _buildTopArea() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTopLeft(),
          _buildTopRight(),
        ],
      ),
    );
  }

  // Left section with title and description
  Widget _buildTopLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "GBP to USD Chart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          "British Pound to US Dollar",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }


  Widget _buildTopRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Text(
          "1 GBP = 1.37684 USD",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          "Jul 26, 2021, 08:59 UTC",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
