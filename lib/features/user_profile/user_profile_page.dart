import 'package:flutter/material.dart';


class UserProfilePage extends StatelessWidget {
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
      color: Colors.white, // Sidebar background color
      child: SingleChildScrollView(
        // Bọc trong SingleChildScrollView để có thể cuộn khi quá dài
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Căn từ trên xuống
          children: [
            // Sidebar Header (Avatar và thông tin người dùng)

            const SizedBox(height: 20),
            // Sidebar Menu
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
                    borderSide: BorderSide(color: Colors.grey, width: 1),
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
          _buildProfileSection(),
          const SizedBox(height: 20),
          _buildAccountSettings(),
          const SizedBox(height: 20),
          _buildSecuritySettings(),
        ],
      ),
    );
  }

  // Widget để hiển thị từng mục cài đặt

// Widget hiển thị cả Profile và Account Settings cạnh nhau
  Widget _buildProfileAndSettings() {
    return Row(
      children: [
        // Phần profile
        Expanded(
          flex: 2, // Tỉ lệ phần chiếm không gian
          child: _buildProfileSection(),
        ),
        const SizedBox(width: 30), // Khoảng cách giữa 2 phần
        // Phần cài đặt tài khoản
        Expanded(
          flex: 3, // Tỉ lệ phần chiếm không gian
          child: _buildAccountSettings(),
        ),
      ],
    );
  }

// Widget hiển thị phần Profile
  Widget _buildProfileSection() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        SizedBox(width: 20),
        Column(
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
      ],
    );
  }

// Widget hiển thị phần Account Settings
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
            fillColor: Color.fromARGB(255, 232, 228, 240), // Đặt màu nền
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


 