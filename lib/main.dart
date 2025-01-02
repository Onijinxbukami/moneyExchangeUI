import 'package:flutter/material.dart';
import 'components/header_section.dart';
import 'components/footer_section.dart';
import 'components/features_section.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            FeaturesSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
