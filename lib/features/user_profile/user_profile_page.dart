import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/user_profile_widget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? selectedButton;

  void _onButtonPressed(String buttonLabel) {
    setState(() {
      if (selectedButton == buttonLabel) {
        selectedButton = null;
      } else {
        selectedButton = buttonLabel;
      }
    });
  }

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Căn giữa các phần tử
        children: [
          // Ô tìm kiếm sử dụng Expanded để chiếm không gian còn lại
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(right: 16), // Cách biểu tượng thông báo
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
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
              // Handle notification
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(), // Hiển thị phần profile (tài khoản người dùng)
          const SizedBox(height: 20),
          if (selectedButton == 'Account')
            _buildAccountSettings(), // Hiển thị phần chỉnh sửa tài khoản nếu nút "Account" được chọn
          if (selectedButton == 'Security')
            _buildSecuritySettings(), // Hiển thị phần bảo mật nếu nút "Security" được chọn
          if (selectedButton == 'Payment Methods')
            _buildPaymentMethodsSettings(), // Hiển thị phần thanh toán nếu nút "Payment Methods" được chọn
          if (selectedButton == 'Notification')
            _buildNotificationSettings(), // Hiển thị phần thông báo nếu nút "Notification" được chọn
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'bibi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'bibi@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Buttons Section
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.account_circle,
              label: 'Account',
              onPressed: () {
                _onButtonPressed('Account');
              },
              isSelected: selectedButton == 'Account',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.security,
              label: 'Security',
              onPressed: () {
                _onButtonPressed('Security');
              },
              isSelected: selectedButton == 'Security',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.payment,
              label: 'Payment Methods',
              onPressed: () {
                _onButtonPressed('Payment Methods');
              },
              isSelected: selectedButton == 'Payment Methods',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.notifications,
              label: 'Notification',
              onPressed: () {
                _onButtonPressed('Notification');
              },
              isSelected: selectedButton == 'Notification',
            ),
          ],
        ),

        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attach_money, // Icon ví tiền
                    color: Colors.black,
                  ),
                  SizedBox(width: 4), // Khoảng cách giữa icon và text
                  Text(
                    '1,000,000 VND', // Số dư giả định
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // Màu xanh để nổi bật
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // Hiển thị form với hai cột
        Wrap(
          spacing: 10, // Khoảng cách giữa các cột
          runSpacing: 10, // Khoảng cách giữa các hàng
          children: [
            _buildTextField('Last Name', 'Enter your Last Name'),
            _buildTextField('First Name', 'Enter your First Name'),
            _buildTextField('Phone Number', 'Enter your Phone Number'),
            _buildTextField('Email', 'Enter your Email'),
            _buildTextField('Password', 'Enter your Password',
                obscureText: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color.fromARGB(255, 232, 228, 240), // Đặt màu nền
            filled: true, // Áp dụng màu nền
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 6, horizontal: 12), // Giảm khoảng cách bên trong
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSettings() {
    return Center(child: Text('Payment Methods Settings'));
  }

  Widget _buildNotificationSettings() {
    return Center(child: Text('Notification Settings'));
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
          icon: Icons.delete,
          title: 'Delete Account',
        ),
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
}
