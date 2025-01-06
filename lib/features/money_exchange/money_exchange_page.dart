import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/money_exchange/money_exchange_service.dart';

class MoneyExchangePage extends StatefulWidget {
  const MoneyExchangePage({super.key});
  @override
  _MoneyExchangePageState createState() => _MoneyExchangePageState();
}

class _MoneyExchangePageState extends State<MoneyExchangePage> {
  final MoneyExchangeService _menuService = MoneyExchangeService();
  String selectedDeliveryMethod = 'Bank Transfer'; // Default delivery method
  String selectedPartnerBank = 'HSBC';

  final List<String> deliveryMethods = [
    'Bank Transfer',
    'Cash Pickup',
    'Mobile Wallet'
  ];
  final List<String> partnerBanks = ['HSBC', 'Standard Chartered', 'Citibank'];

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

  Widget midHeader() {
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
              color: Color(0xFF00274D),
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
                                      child: SizedBox(
                                        width: 150, // Cố định chiều rộng
                                        child: Text(
                                          method,
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt chữ dài
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF00274D),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDeliveryMethod = value!;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF00274D),
                            ),
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
                            items: partnerBanks.map((bank) {
                              return DropdownMenuItem(
                                value: bank,
                                child: SizedBox(
                                  width: 150, // Cố định chiều rộng
                                  child: Text(
                                    bank,
                                    overflow:
                                        TextOverflow.ellipsis, // Cắt chữ dài
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPartnerBank = value!;
                              });
                            },
                            isExpanded:
                                true, // Đảm bảo chiếm toàn bộ chiều rộng
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
          const Divider(color: Colors.black),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Nền sáng
              borderRadius: BorderRadius.circular(10), // Bo góc
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bóng nhẹ
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildTransactionDetail(
              title: 'Total Pay',
              value: 'Same Day',
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              valueStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6200EE), // Màu tím nổi bật
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Nền sáng
              borderRadius: BorderRadius.circular(10), // Bo góc
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bóng nhẹ
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildTransactionDetail(
              title: 'Recipient gets',
              value: 'Same Day',
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              valueStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6200EE), // Màu tím nổi bật
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.black),

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                    height: 30), // Khoảng cách giữa dropdown và nút Continue
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Hành động khi bấm nút Continue
                      debugPrint('Continue pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF6200EE), // Màu tím nổi bật
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 30), // Padding nhỏ hơn
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Bo tròn góc nút
                      ),
                      elevation: 6, // Hiệu ứng đổ bóng
                      shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng nhẹ
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20), 
                        SizedBox(width: 8), 
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2, 
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail({
    required String title,
    required String value,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style:
              valueStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
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
}
