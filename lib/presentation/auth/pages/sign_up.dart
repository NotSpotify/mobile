import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/common/widgets/input/basic_textfield.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isObscured = true;
  bool _isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset(AppVectors.logo, height: 30, width: 30),
                  // Spacer(flex: 0),
                  SizedBox(height: 40),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign up to create a new account.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 40),
                  BasicTextfield(hintText: "Enter Full Name"),
                  SizedBox(height: 10),

                  BasicTextfield(hintText: "Enter Email"),
                  SizedBox(height: 10),
                  BasicTextfield(
                    hintText: 'Enter Password',
                    isPassword: _isPassword,
                    isObscured: true,
                    suffixIcon: IconButton(
                      iconSize: 20,
                      color: Colors.black54,
                      padding: EdgeInsets.all(5),
                      icon:
                          _isObscured
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                          _isPassword = !_isPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  BasicAppButton(
                    color: AppColors.primary,
                    title: 'Sign In',
                    onPressed: () {},
                    height: 80,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.grey,
                          height: 40,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.grey,
                          height: 40,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          AppVectors.google, // Replace with your SVG path
                          height: 40,
                          width: 40,
                        ),
                        onPressed: () {
                          print('Google Icon Pressed');
                        },
                      ),
                      SizedBox(width: 30),
                      IconButton(
                        icon: SvgPicture.asset(
                          AppVectors.apple, // Replace with your SVG path
                          height: 40,
                          width: 40,
                        ),
                        onPressed: () {
                          print('Facebook Icon Pressed');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have account?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Add navigation logic here
                        },
                        child: Text(
                          ' Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppColors.primary, // Set underline color
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                    ],
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
