import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:js' as js;

class SettingForm extends StatefulWidget {
  const SettingForm({super.key});

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationNumberController =
      TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  Uint8List? _idFrontPhoto;
  Uint8List? _idRearPhoto;
  Uint8List? _passportPhoto;
  final ImagePicker _picker = ImagePicker();
  bool _showIdentificationField = false;
  bool _showPassportField = false;
  final List<Map<String, String>> nationalities = [
    {"name": "American"},
    {"name": "British"},
    {"name": "Canadian"},
    {"name": "Chinese"},
    {"name": "French"},
    {"name": "German"},
    {"name": "Indian"},
    {"name": "Japanese"},
    {"name": "Korean"},
    {"name": "Vietnamese"},
  ];
  List<Map<String, String>> filteredNationalities = [];

  @override
  void dispose() {
    _userNameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nationalityController.dispose();
    _identificationNumberController.dispose();
    _passportNumberController.dispose();
    _bankCodeController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> updateUserInformation({
    required String userId,
    required String userName,
    required String firstName,
    required String lastName,
    required String address,
    required String nationality,
    Uint8List? idFrontPhoto,
    Uint8List? idRearPhoto,
    Uint8List? passportPhoto,
  }) async {
    try {
      // Tham chiếu đến document của người dùng trong collection 'users'
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      Future<String?> uploadImage(Uint8List? imageBytes, String path) async {
        if (imageBytes == null) return null;
        Reference ref = FirebaseStorage.instance.ref().child(path);
        UploadTask uploadTask = ref.putData(imageBytes);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }

      String? idFrontUrl =
          await uploadImage(idFrontPhoto, 'users/$userId/id_front.jpg');
      String? idRearUrl =
          await uploadImage(idRearPhoto, 'users/$userId/id_rear.jpg');
      String? passportUrl =
          await uploadImage(passportPhoto, 'users/$userId/passport.jpg');

      // Cập nhật các trường thông tin
      Map<String, dynamic> updatedData = {
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'nationality': nationality,
      };
      if (idFrontUrl != null) updatedData['idFrontPhoto'] = idFrontUrl;
      if (idRearUrl != null) updatedData['idRearPhoto'] = idRearUrl;
      if (passportUrl != null) updatedData['passportPhoto'] = passportUrl;

      // Cập nhật Firestore
      await userRef.update(updatedData);

      print('User information updated successfully');
    } catch (e) {
      print('Error updating user information: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // If data exists, update controllers
        if (userDoc.exists) {
          final userData = userDoc.data();
          setState(() {
            _userNameController.text = userData?['userName'] ?? '';
            _phoneNumberController.text = userData?['phoneNumber'] ?? '';
            _emailController.text = userData?['email'] ?? '';
            _firstNameController.text = userData?['firstName'] ?? '';
            _lastNameController.text = userData?['lastName'] ?? '';
            _addressController.text = userData?['address'] ?? '';
            _nationalityController.text = userData?['nationality'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;

      // Use email and old password to reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      // Optional: Update Firestore if needed
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'passwordUpdatedAt': FieldValue.serverTimestamp()});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password change failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      var fb = js.context['FB'];

      // Kiểm tra nếu Facebook SDK đã sẵn sàng
      if (fb != null && fb.callMethod != null) {
        print("Logging out from Facebook...");

        // Gọi FB.logout() để đăng xuất khỏi Facebook
        fb.callMethod('logout', [
          js.allowInterop((response) {
            print("User logged out from Facebook.");
          })
        ]);
      }

      // Đăng xuất khỏi Firebase
      await FirebaseAuth.instance.signOut();
      print('User logged out successfully from Firebase');

      // Điều hướng về màn hình đăng nhập
      Navigator.pushReplacementNamed(context, Routes.login);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout successful'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterNationalities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNationalities = [];
      } else {
        filteredNationalities = nationalities
            .where((nationality) => nationality['name']!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
    if (filteredNationalities.isNotEmpty) {
      _showNationalityDialog();
    }
  }

  void _showNationalityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Nationality'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filteredNationalities.map((nationality) {
              return ListTile(
                title: Text(nationality['name']!),
                onTap: () {
                  setState(() {
                    _nationalityController.text = nationality['name']!;
                    filteredNationalities = [];
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
    return DefaultTabController(
      length: 2, // Length of tabs
      child: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            backgroundColor: Colors.white, // AppBar background color to white
            elevation: 0, // Remove shadow from AppBar

            bottom: TabBar(
              tabs: [
                Tab(text: tr('account_details')),
                Tab(text: tr('bank_details')),
              ],
              indicatorColor: Colors.blue, // Indicator color for active tab
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // TabBarView should take up all available space, use Expanded
              Expanded(
                child: TabBarView(
                  children: [
                    // Wrap content with SingleChildScrollView to handle overflow
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildAccountSettings(), // Your content here
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildBankSetting(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankSetting() {
    return Column(
      // Removed the extra SingleChildScrollView
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTextField(
              tr('bank_code'),
              tr('enter_bank_code'),
              controller: _bankCodeController,
            ),
            _buildTextField(
              tr('bank_name'),
              tr('enter_bank_name'),
              controller: _bankNameController,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle account update
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            tr('update'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      // Removed the extra SingleChildScrollView
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTextField(
              tr('user_name'),
              tr('enter_username'),
              controller: _userNameController,
            ),
            _buildTextField(
              tr('last_name'),
              tr('enter_last_name'),
              controller: _lastNameController,
            ),
            _buildTextField(
              tr('first_name'),
              tr('enter_first_name'),
              controller: _firstNameController,
            ),
            _buildConditionalTextField(
              label: tr('identification_number'),
              hint: tr('enter_identification_number'),
              isVisible: _showIdentificationField,
              onCheckboxChanged: (bool? value) {
                setState(() {
                  _showIdentificationField = value ?? false;
                });
              },
              controller: _identificationNumberController,
            ),
            _buildConditionalTextField(
              label: tr('passport_number'),
              hint: tr('enter_passport_number'),
              isVisible: _showPassportField,
              onCheckboxChanged: (bool? value) {
                setState(() {
                  _showPassportField = value ?? false;
                });
              },
              controller: _passportNumberController,
            ),
            _buildPhotoUploader(
              title: tr('id_front_photo'),
              photoBytes: _idFrontPhoto,
              photoType: 'idFront',
            ),
            _buildPhotoUploader(
              title: tr('id_rear_photo'),
              photoBytes: _idRearPhoto,
              photoType: 'idRear',
            ),
            _buildPhotoUploader(
              title: tr('passport_photo'),
              photoBytes: _passportPhoto,
              photoType: 'passport',
            ),
            Text(tr('nationality'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _nationalityController,
              onChanged: (value) {
                //print('TextField value: $value'); // Debug log
                filterNationalities(value); // Gọi hàm lọc
              },
              decoration: InputDecoration(
                hintText: tr('enter_nationality'),
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            _buildTextField(
              tr('address'),
              tr('enter_address'),
              controller: _addressController,
            ),
            _buildTextField(
              tr('phone_number'),
              tr('enter_phone_number'),
              controller: _phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr('phone_number_required');
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return tr('phone_number_invalid');
                }
                return null;
              },
            ),
            _buildTextField(
              tr('email'),
              tr('enter_email'),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr('email_required');
                }
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value)) {
                  return tr('email_invalid');
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Show the password change dialog when the button is pressed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(tr('change_password')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Old Password TextField
                      TextField(
                        controller: oldPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: tr('old_password'),
                          hintText: tr('enter_old_password'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // New Password TextField
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: tr('new_password'),
                          hintText: tr('enter_new_password'),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(tr('cancel')),
                    ),
                    // Submit button
                    ElevatedButton(
                      onPressed: () async {
                        final oldPassword = oldPasswordController.text.trim();
                        final newPassword = newPasswordController.text.trim();

                        // Call changePassword function
                        await changePassword(
                          context: context,
                          oldPassword: oldPassword,
                          newPassword: newPassword,
                        );

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4743C9),
                      ),
                      child: Text(
                        tr('change_password'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            tr('change_password'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            String userId = FirebaseAuth.instance.currentUser!.uid;
            String userName = _userNameController.text;
            String firstName = _firstNameController.text;
            String lastName = _lastNameController.text;
            String address = _addressController.text;
            String nationality = _nationalityController.text;

            try {
              await updateUserInformation(
                userId: userId,
                userName: userName,
                firstName: firstName,
                lastName: lastName,
                address: address,
                nationality: nationality,
                idFrontPhoto: _idFrontPhoto,
                idRearPhoto: _idRearPhoto,
                passportPhoto: _passportPhoto,
              );

              // ✅ Hiển thị thông báo khi cập nhật thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tr('update_success'), // Sử dụng localization nếu có
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      Colors.green, // Màu nền xanh lá cho trạng thái thành công
                  duration: Duration(seconds: 3),
                ),
              );
            } catch (e) {
              // ❌ Hiển thị lỗi nếu có lỗi xảy ra
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tr('update_failed'), // Sử dụng localization nếu có
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red, // Màu nền đỏ cho trạng thái lỗi
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            tr('update'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _handleLogout(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            tr('logout'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionalTextField({
    required String label,
    required String hint,
    required bool isVisible,
    required ValueChanged<bool?> onCheckboxChanged,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: isVisible,
              onChanged: (value) {
                onCheckboxChanged(value);
              },
              activeColor: Colors.blueAccent,
            ),
          ],
        ),
        if (isVisible) ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              fillColor: Colors.grey.shade100,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
          validator: validator,
        ),
      ],
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
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(tr('edit_photo')),
                      ],
                    ),
                  ),
                if (photoBytes != null)
                  PopupMenuItem(
                    value: 'Remove',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text(tr('remove_photo')),
                      ],
                    ),
                  ),
                if (photoBytes == null)
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.upload_file, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(tr('upload_photo')),
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
