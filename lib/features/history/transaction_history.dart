import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';

class TransactionHistoryForm extends StatefulWidget {
  const TransactionHistoryForm({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _TransactionHistoryFormState createState() => _TransactionHistoryFormState();
}

class _TransactionHistoryFormState extends State<TransactionHistoryForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6610F2),
        leading: isMobile
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
      ),
      drawer: isMobile ? Sidebar() : null,
      body: Row(
        children: [
          if (!isMobile) Sidebar(), // Sidebar cố định trên web

          // User Information and Content Area
          Expanded(
            child: Column(
              children: [
                // Header Section
                HeaderWidget(), // Giả sử bạn đã có widget HeaderWidget
                // Content Section
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.95,
              child: Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MediaQuery.of(context).size.width > 600
                      // Trên màn hình máy tính, không cuộn và có viền đầy đủ
                      ? DataTable(
                          columnSpacing: 24,
                          headingRowHeight: 60,
                          dataRowHeight: 60,
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Amount')),
                          ],
                          rows: [
                            _buildStyledDataRow(
                              name: 'Coffee Shop',
                              date: '2023-12-01',
                              status: 'Completed',
                              amount: '-\$5.00',
                              statusColor: Colors.green,
                            ),
                            _buildStyledDataRow(
                              name: 'Groceries',
                              date: '2023-12-02',
                              status: 'Pending',
                              amount: '-\$150.00',
                              statusColor: Colors.orange,
                            ),
                            _buildStyledDataRow(
                              name: 'Salary',
                              date: '2023-12-03',
                              status: 'Completed',
                              amount: '+\$2,000.00',
                              statusColor: Colors.green,
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 24,
                            headingRowHeight: 60,
                            dataRowHeight: 60,
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            border: TableBorder(
                              horizontalInside: BorderSide.none,
                              verticalInside: BorderSide.none,
                            ), // Loại bỏ viền trên điện thoại
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Amount')),
                            ],
                            rows: [
                              _buildStyledDataRow(
                                name: 'Coffee Shop',
                                date: '2023-12-01',
                                status: 'Completed',
                                amount: '-\$5.00',
                                statusColor: Colors.green,
                              ),
                              _buildStyledDataRow(
                                name: 'Groceries',
                                date: '2023-12-02',
                                status: 'Pending',
                                amount: '-\$150.00',
                                statusColor: Colors.orange,
                              ),
                              _buildStyledDataRow(
                                name: 'Salary',
                                date: '2023-12-03',
                                status: 'Completed',
                                amount: '+\$2,000.00',
                                statusColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildStyledDataRow({
    required String name,
    required String date,
    required String status,
    required String amount,
    required Color statusColor,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(
          date,
          style: const TextStyle(fontSize: 14),
        )),
        DataCell(Row(
          children: [
            Icon(Icons.circle, size: 10, color: statusColor),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(fontSize: 14, color: statusColor),
            ),
          ],
        )),
        DataCell(Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            color: amount.startsWith('-') ? Colors.red : Colors.green,
          ),
        )),
      ],
    );
  }
}
