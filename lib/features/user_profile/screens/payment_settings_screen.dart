import 'package:flutter/material.dart';

class PaymentSettings extends StatefulWidget {
  const PaymentSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentSettingsState createState() => _PaymentSettingsState();
}

class _PaymentSettingsState extends State<PaymentSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Linked Payment system',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCardButton(
                  'assets/images/visa-card.png', 'transactionsMod'),
              _buildCardButton(
                  'assets/images/paylio-card.png', 'transactionsMod'),
              _buildCardButton(
                  'assets/images/paypal-card.png', 'transactionsMod'),
              _buildCardButton(
                  'assets/images/blockchain-card.png', 'transactionsMod'),
              _buildCardButton('assets/images/add-new.png', 'addcardMod'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardButton(String imagePath, String modalTarget) {
    return GestureDetector(
      onTap: () {
        // Open modal by target
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('This would open $modalTarget modal'),
            );
          },
        );
      },
      child: Container(
        width: 120,
        height: 180,
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
