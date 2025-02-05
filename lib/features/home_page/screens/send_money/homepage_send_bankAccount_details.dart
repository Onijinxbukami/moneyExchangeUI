import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomepageBankAccountDetailsPage extends StatefulWidget {
  const HomepageBankAccountDetailsPage({super.key});

  @override
  _HomepageBankAccountDetailsPageState createState() =>
      _HomepageBankAccountDetailsPageState();
}

class _HomepageBankAccountDetailsPageState
    extends State<HomepageBankAccountDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankCodeController = TextEditingController();

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
  String _selectedLanguage = 'EN';
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
        appBar: AppBar(
          backgroundColor: const Color(0xFF6610F2),
          title: _buildHeader(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            ProgressStepper(
              steps: const [
                "Amount",
                "Sender",
                "Recipient",
                "Review",
                "Pay",
              ],
              currentStep: 2, // Giá trị bước hiện tại
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: isSmallScreen ? 8 : 10,
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
                  Tab(text: 'Near me', icon: Icon(Icons.notifications)),
                  Tab(text: 'Send', icon: Icon(Icons.security)),
                  Tab(text: 'Setting', icon: Icon(Icons.new_releases)),
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
      color: const Color(0xFF6610F2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Canh đều giữa Dropdown và Login
        children: [
          // Dropdown chọn ngôn ngữ
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Colors.white,
            items: ['EN', 'BN', 'ES', 'NL']
                .map(
                  (lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(
                      lang,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          // Nút Login
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.login);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget midHeader(double fontSize, double padding) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Recipient Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const Divider(color: Colors.black),

            const SizedBox(height: 10),
            const Text(
              'Full legal first and middlde name',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
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
                hintText: 'YYYY-MM-DD',
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
                hintText: 'e.g. +123456789',
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

            const Text(
              'Mail',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your mail',
                hintText: 'Type something...',
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),

            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Text(
              'Recipient bank details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),

            const SizedBox(height: 10),
            const Text(
              'Full name of the account holder',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: accountNameController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 10),
            const Text(
              'Account number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: accountNumberController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 10),

            const Text(
              'Bank code',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bankCodeController,
              onChanged: filterdBankCode,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
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
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 20),

            // Danh sách gợi ý
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap:
                        true, // Make the ListView take up only the space it needs
                    itemCount: filteredBankCode.length,
                    itemBuilder: (context, index) {
                      var bankCode = filteredBankCode[index];
                      return ListTile(
                        title: Text(bankCode['code'] ??
                            'No Code'), // Fallback if 'code' is null
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bankCode['name'] ??
                                'No Name'), // Fallback if 'name' is null
                            const SizedBox(height: 5),
                          ],
                        ),
                        onTap: () {
                          // When an item is tapped, set the name into the TextField's controller
                          setState(() {
                            bankCodeController.text =
                                bankCode['name'] ?? 'No Name';
                            // Optionally, close the list by clearing filtered results
                            filteredBankCode
                                .clear(); // Clear the list or you can use visibility to hide the list
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Khoảng cách giữa ListView và nút
            Center(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.addressDetails);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Continue Pressed!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6200EE),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 600 ? 40 : 80,
                  vertical: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                ),
                minimumSize: Size(
                  double.infinity,
                  MediaQuery.of(context).size.width < 600 ? 48 : 56,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 6,
                shadowColor: Colors.grey.withOpacity(0.5),
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
                      fontSize:
                          MediaQuery.of(context).size.width < 600 ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
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
