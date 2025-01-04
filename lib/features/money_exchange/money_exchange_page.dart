import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/money_exchange/money_exchange_service.dart';

class MoneyExchangePage extends StatelessWidget {
  final MoneyExchangeService _menuService = MoneyExchangeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(context),
          // User Information Area
          Expanded(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSidebarItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                // Handle Dashboard tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.person,
              title: 'Transaction',
              onTap: () {
                // Handle Transaction tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.payments,
              title: 'Pay',
              onTap: () {
                // Handle Pay tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.account_balance_wallet,
              title: 'Receive',
              onTap: () {
                // Handle Receive tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.expand,
              title: 'Exchange',
              onTap: () {
                // Handle Exchange tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.attach_money,
              title: 'Deposit Money',
              onTap: () {
                // Handle Deposit Money tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.money_off,
              title: 'Withdraw Money',
              onTap: () {
                // Handle Withdraw Money tap
              },
            ),
            const Divider(color: Colors.black),
            _buildSidebarItem(
              icon: Icons.support_agent,
              title: 'Support',
              onTap: () {
                // Handle Support tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.settings,
              title: 'Setting',
              onTap: () {
                // Handle Logout tap
              },
            ),
            _buildSidebarItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                // Handle Logout tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 16), // Căn đều bằng margin
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white, // Giữ màu nền là trắng cho tất cả mục
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black, // Đặt màu icon là đen
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black, // Đặt màu chữ là đen
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal, // Chữ đậm khi chọn
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFFF7F9FD), // Màu nền cho toàn bộ header
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Căn giữa các phần tử
            children: [
              // Ô tìm kiếm
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      right: 16), // Cách biểu tượng thông báo
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600], // Màu của biểu tượng kính lúp
                      ),
                    ),
                  ),
                ),
              ),
              // Biểu tượng thông báo
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Xử lý sự kiện thông báo
                },
              ),
              // Thông tin người dùng (avatar và menu)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25, // Kích thước nhỏ hơn để phù hợp với Header
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 12), // Khoảng cách giữa avatar và menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _menuService
                          .onMenuItemSelected(value); // Hàm xử lý khi chọn menu
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'settings',
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          midHeader(),
          const SizedBox(height: 20),
          _buildSecuritySettings(),
          // Now works correctly
        ],
      ),
    );
  }

  Widget midHeader() {
    // State variables for dropdown selections
    String selectedDeliveryMethod = 'Bank Transfer'; // Default delivery method
    String selectedPartnerBank = 'HSBC'; // Default partner bank

    final List<String> deliveryMethods = [
      'Bank Transfer',
      'Cash Pickup',
      'Mobile Wallet'
    ];
    final List<String> partnerBanks = [
      'HSBC',
      'Standard Chartered',
      'Citibank'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Money Exchange',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00274D), // Màu sắc dễ nhìn
            ),
          ),
          const Divider(height: 20, thickness: 1, color: Colors.grey),
          const SizedBox(height: 10),

          // Money Exchange Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "You Send" Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExchangeCard(
                        title: 'You Send',
                        amount: '400.00',
                        balance: '\$30,700.00',
                        currency: 'USD',
                        flag: Icons.flag, // Placeholder for flag icon
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Delivery Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00274D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Delivery Method
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDeliveryMethod,
                            items: deliveryMethods
                                .map((method) => DropdownMenuItem(
                                      value: method,
                                      child: Text(
                                        method,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF00274D),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              // Cập nhật selectedDeliveryMethod

                              selectedDeliveryMethod = value!;
                            },
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xFF00274D)),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.purple,
                child: Icon(Icons.swap_horiz, color: Colors.white),
              ),
              const SizedBox(width: 10),
              // "Recipient Gets" Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExchangeCard(
                        title: 'Recipient Gets',
                        amount: '45162.98',
                        balance: "Today's rate: 1 GBP = 112.90745 BDT",
                        currency: 'BDT',
                        flag: Icons.flag, // Placeholder for flag icon
                        cardColor: const Color(0xFFEAE6FA),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bank Transfer Partner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00274D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Partner Bank
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPartnerBank,
                            items: partnerBanks
                                .map((bank) => DropdownMenuItem(
                                      value: bank,
                                      child: Text(
                                        bank,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF00274D),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedPartnerBank = value!;
                            },
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xFF00274D)),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Transaction details
          _buildTransactionDetail(
            title: 'Estimated fee',
            value: '+0.33 GBP',
          ),
          const SizedBox(height: 20),
          _buildTransactionDetail(
            title: 'Transfer time',
            value: 'Same Day',
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Logout',
        ),
      ],
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      onTap: () {
        // Handle setting item tap
      },
    );
  }

  Widget _buildExchangeCard({
    required String title,
    required String amount,
    required String balance,
    required String currency,
    required IconData flag,
    Color cardColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(flag, size: 24, color: Colors.black),
              const SizedBox(width: 5),
              Text(
                currency,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            balance,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail(
      {required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
