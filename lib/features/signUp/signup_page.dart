import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: lightColor,
        elevation: 0,
        toolbarHeight: 80,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề "MoneyExchange" ở bên trái
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 20), // Cách lề trái và lề trên
              child: Text(
                "MoneyExchange",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Nút Login ở bên phải
          Padding(
            padding: const EdgeInsets.only(
                top: 10, right: 20), // Cách lề phải và lề trên
            child: ElevatedButton(
              onPressed: () {
                // Handle login action
              },
              child: const Text("Login", style: buttonTextStyle),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4743C9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1), // Chiều cao của Divider
          child: Divider(
            color: Colors.black, // Màu của đường line
            thickness: 1, // Độ dày của đường line
            indent: 0, // Khoảng cách từ trái
            endIndent: 0, // Khoảng cách từ phải
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login-reg-bg.png'),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "ACCOUNT",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4743C9),
                        letterSpacing: 1.5,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Don't have an account?" text with the login button next to it
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align the row
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 37, 34, 109),
                            letterSpacing: 1.5,
                            height: 1.2,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle login action
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4743C9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Register to continue
                  const Center(
                    child: Text(
                      "REGISTER TO CONTINUE",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 37, 34, 109),
                        letterSpacing: 1.2,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Username Input
                  const Text("Username", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  TextField(
                    obscureText: true,
                    decoration: inputFieldDecoration.copyWith(
                      hintText: "Enter Your Username",
                    ),
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Email Input
                  const Text("Email", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  TextField(
                    decoration: inputFieldDecoration.copyWith(
                      hintText: "Enter Your Email",
                    ),
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Password Input
                  const Text("Password", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  TextField(
                    obscureText: true,
                    decoration: inputFieldDecoration.copyWith(
                      hintText: "Enter Your Password",
                    ),
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Sign Up Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle signup
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4743C9), // Button color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 16,
                        ),
                        minimumSize: const Size(
                            double.infinity, 56), // Full width and fixed height
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16, // Font size for button text
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
