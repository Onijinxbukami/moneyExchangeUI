import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomepageUserDetailsPage extends StatefulWidget {
  const HomepageUserDetailsPage({super.key});

  @override
  _HomepageUserDetailsPageState createState() =>
      _HomepageUserDetailsPageState();
}

class _HomepageUserDetailsPageState extends State<HomepageUserDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankCodeController = TextEditingController();
  bool _isGmailError = false;
  bool _isFullNameError = false;
  bool _isAccountNameError = false;
  bool _isAccountNumberError = false;
  bool _isBankCodeError = false;

  String _selectedLanguage = 'EN';
  final List<Map<String, String>> bankCodes = [
    {
      "code": "001",
      "name": "Bank A",
    },
    {
      "code": "002",
      "name": "Bank B",
    },
    {
      "code": "003",
      "name": "Bank C",
    },
    {
      "code": "004",
      "name": "Bank D",
    },
    {
      "code": "005",
      "name": "Bank E",
    },
    {
      "code": "006",
      "name": "Bank F",
    },
    {
      "code": "007",
      "name": "Bank G",
    },
    {
      "code": "008",
      "name": "Bank H",
    },
    {
      "code": "009",
      "name": "Bank I",
    },
    {
      "code": "010",
      "name": "Bank J",
    },
  ];
  List<Map<String, String>> filteredBankCode = [];
  Uint8List? _idFrontPhoto;
  Uint8List? _idRearPhoto;
  Uint8List? _passportPhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  void filterdBankCode(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBankCode = [];
      } else {
        filteredBankCode = bankCodes
            .where((outlet) =>
                (outlet['code'] != null &&
                    outlet['code']!
                        .toLowerCase()
                        .contains(query.toLowerCase())) ||
                (outlet['name'] != null &&
                    outlet['name']!
                        .toLowerCase()
                        .contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  void _validatePhoneNumber(String value) {
    // Kiểm tra nếu đầu vào có ký tự không phải số
    if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter only numbers")),
      );
    }
  }

  Future<void> _pickImage(String photoType) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      setState(() {
        if (photoType == 'idFront') {
          _idFrontPhoto = imageBytes;
        } else if (photoType == 'idRear') {
          _idRearPhoto = imageBytes;
        } else if (photoType == 'passport') {
          _passportPhoto = imageBytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen =
        screenWidth < 600; // Kiểm tra chiều rộng màn hình

    final double padding = isSmallScreen ? 12.0 : 16.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: const Color(0xFF6610F2), // Màu nền AppBar
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                        width: 8), // Khoảng cách giữa icon và tiêu đề
                    Expanded(child: _buildHeader()), // Tiêu đề AppBar
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
ProgressStepper(
  steps: ["Amount", "Sender", "Recipient", "Review", "Success"],
  stepIcons: [
    Icons.attach_money,
    Icons.person,
    Icons.people,
    Icons.checklist,
    Icons.verified
  ],
  currentStep: 1,
  backgroundColor: Colors.grey[300]!,
  progressColor: Colors.blue,
  height: 8,
),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // TabBar phía trên nội dung chính

            const SizedBox(height: 16),

            // Phần nội dung cuộn chính
            Expanded(
              child: TabBarView(
                children: [
                  LocationForm(),
                  _buildContent(fontSize, padding), // Nội dung cho "Near me"
                  SettingForm(), // Nội dung cho "Setting"
                ],
              ),
            ),

            // TabBar phía dưới nội dung chính
            Container(
              color: const Color(0xFF5732C6),
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Near me', icon: Icon(Icons.map)),
              Tab(text: 'Send', icon: Icon(Icons.send)),
              Tab(text: 'Setting', icon: Icon(Icons.settings)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF6610F2), // Màu tím nhạt theo phong cách Apple
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Language Dropdown với Cupertino Style
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: const Text("Select Language"),
                        actions: ['EN', 'VN']
                            .map(
                              (lang) => CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _selectedLanguage = lang;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(lang),
                              ),
                            )
                            .toList(),
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Text(
                      _selectedLanguage,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const Icon(CupertinoIcons.chevron_down, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // StreamBuilder for User Authentication Status
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator(color: Colors.white);
              }

              if (snapshot.hasData) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data!.uid)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CupertinoActivityIndicator(
                          color: Colors.white);
                    }

                    if (userSnapshot.hasData) {
                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      return Row(
                        children: [
                          const Icon(CupertinoIcons.person_circle_fill,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            userData['username'] ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }

                    return const Text('Error',
                        style: TextStyle(color: Colors.white));
                  },
                );
              }

              // Nếu chưa đăng nhập, hiển thị nút "Login" theo chuẩn Apple
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget midHeader(double fontSize, double padding) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double padding = isSmallScreen ? 12.0 : 24.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const Divider(color: Colors.black),

            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Full legal first and middle name ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00274D),
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your full legal name',
                    labelStyle: const TextStyle(fontSize: 14),
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText:
                        _isFullNameError ? 'Full name is required' : null,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onTapOutside: (_) {
                    // Khi ấn ra ngoài mà chưa nhập, hiển thị lỗi
                    if (nameController.text.isEmpty) {
                      setState(() {
                        _isFullNameError = true;
                      });
                    }
                  },
                  onChanged: (value) {
                    // Nếu có nhập thì ẩn lỗi
                    if (value.isNotEmpty && _isFullNameError) {
                      setState(() {
                        _isFullNameError = false;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Date of Birth',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  dobController.text =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                }
              },
              decoration: InputDecoration(
                labelText: 'Select your date of birth',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 20),

            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                _validatePhoneNumber(
                    value); // Truyền trực tiếp giá trị của input
              },
              decoration: InputDecoration(
                labelText: 'Enter your phone number',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Email ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00274D),
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: _isGmailError ? 'Email is required' : null,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onTapOutside: (_) {
                    // Khi ấn ra ngoài mà chưa nhập, hiển thị lỗi
                    if (emailController.text.isEmpty) {
                      setState(() {
                        _isGmailError = true;
                      });
                    }
                  },
                  onChanged: (value) {
                    // Nếu có nhập thì ẩn lỗi
                    if (value.isNotEmpty && _isGmailError) {
                      setState(() {
                        _isGmailError = false;
                      });
                    }
                  },
                ),
              ],
            ),

            _buildPhotoUploader(
              title: 'ID Front Photo',
              photoBytes: _idFrontPhoto,
              photoType: 'idFront',
            ),
            _buildPhotoUploader(
              title: 'ID Rear Photo',
              photoBytes: _idRearPhoto,
              photoType: 'idRear',
            ),
            _buildPhotoUploader(
              title: 'Passport Photo',
              photoBytes: _passportPhoto,
              photoType: 'passport',
            ),
            const SizedBox(height: 20), // Khoảng cách giữa ListView và nút
            const Center(
              child: Text(
                'Bank Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Name
                RichText(
                  text: const TextSpan(
                    text: 'Account name ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00274D),
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: accountNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your account name',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText:
                        _isAccountNameError ? 'Account name is required' : null,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onTapOutside: (_) {
                    if (accountNameController.text.isEmpty) {
                      setState(() => _isAccountNameError = true);
                    }
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty && _isAccountNameError) {
                      setState(() => _isAccountNameError = false);
                    }
                  },
                ),

                const SizedBox(height: 10),

                // Account Number
                RichText(
                  text: const TextSpan(
                    text: 'Account Number ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00274D),
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter your account number',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: _isAccountNumberError
                        ? 'Account number is required'
                        : null,
                  ),
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  onTapOutside: (_) {
                    if (accountNumberController.text.isEmpty) {
                      setState(() => _isAccountNumberError = true);
                    }
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty && _isAccountNumberError) {
                      setState(() => _isAccountNumberError = false);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label với dấu * yêu cầu nhập
                RichText(
                  text: const TextSpan(
                    text: 'Bank name ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00274D),
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // TextField với validation
                TextField(
                  controller: bankCodeController,
                  onChanged: (value) {
                    filterdBankCode(value);
                    if (value.isNotEmpty && _isBankCodeError) {
                      setState(() => _isBankCodeError = false);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter bank name',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText:
                        _isBankCodeError ? 'Bank name is required' : null,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onTapOutside: (_) {
                    if (bankCodeController.text.isEmpty) {
                      setState(() => _isBankCodeError = true);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Danh sách ngân hàng gợi ý
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredBankCode.length,
                        itemBuilder: (context, index) {
                          var bankCode = filteredBankCode[index];
                          return ListTile(
                            title: Text(bankCode['code'] ?? 'No Code'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bankCode['name'] ?? 'No Name'),
                                const SizedBox(height: 5),
                              ],
                            ),
                            onTap: () {
                              // Khi chọn ngân hàng, cập nhật ô nhập và ẩn danh sách
                              setState(() {
                                bankCodeController.text =
                                    bankCode['name'] ?? 'No Name';
                                filteredBankCode
                                    .clear(); // Ẩn danh sách sau khi chọn
                                _isBankCodeError = false; // Ẩn lỗi nếu có
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Continue pressed');
                        Navigator.pushNamed(context, Routes.bankAccountDetails);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Continue Pressed!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth < 600 ? 40 : 80,
                          vertical: screenWidth < 600 ? 12 : 16,
                        ),
                        minimumSize: Size(
                          double.infinity,
                          screenWidth < 600 ? 48 : 56,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 3,
                        shadowColor: Colors.grey.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 16 : 20,
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
      ),
    );
  }

  Widget _buildContent(double fontSize, double padding) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          midHeader(fontSize, padding),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPhotoUploader({
    required String title,
    required Uint8List? photoBytes,
    required String photoType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit') {
                  _pickImage(photoType);
                } else if (value == 'Remove') {
                  setState(() {
                    if (photoType == 'idFront') {
                      _idFrontPhoto = null;
                    } else if (photoType == 'idRear') {
                      _idRearPhoto = null;
                    } else if (photoType == 'passport') {
                      _passportPhoto = null;
                    }
                  });
                }
              },
              icon: Icon(
                photoBytes == null ? Icons.upload_file : Icons.more_vert,
                color: photoBytes == null ? Colors.blue : Colors.green,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              elevation: 4,
              itemBuilder: (context) => [
                if (photoBytes != null)
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit Photo'),
                      ],
                    ),
                  ),
                if (photoBytes != null)
                  PopupMenuItem(
                    value: 'Remove',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Remove Photo'),
                      ],
                    ),
                  ),
                if (photoBytes == null)
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: const [
                        Icon(Icons.upload_file, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Upload Photo'),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (photoBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              photoBytes,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
