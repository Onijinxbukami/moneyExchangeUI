class MoneyExchangeService {
  void onMenuItemSelected(String value) {
    switch (value) {
      case 'settings':
        // Điều hướng đến màn hình Settings
        print('Settings selected');
        break;
      case 'logout':
        // Thực hiện đăng xuất
        print('Logout selected');
        break;
    }
  }
}
