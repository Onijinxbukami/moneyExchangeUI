import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Our Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Feature 1: Awesome functionality'),
          Text('Feature 2: Easy to use'),
          Text('Feature 3: Highly customizable'),
        ],
      ),
    );
  }
}
