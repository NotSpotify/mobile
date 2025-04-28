import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/appbar/basic_app_bar.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/common/widgets/input/basic_textfield.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';
import 'package:notspotify/domain/usecases/auth/signin.dart';
import 'package:notspotify/domain/usecases/auth/signin_google.dart';
import 'package:notspotify/presentation/auth/pages/sign_up.dart';
import 'package:notspotify/presentation/home/pages/home.dart';
import 'package:notspotify/service_locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isObscured = true;
  bool _isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ), // 👈 Use your custom app bar here
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome back! Please sign in to your account.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40),
            BasicTextfield(hintText: "Enter Email", controller: _email),
            SizedBox(height: 10),
            BasicTextfield(
              controller: _password,
              hintText: 'Enter Password',
              isPassword: _isPassword,
              isObscured: _isObscured,
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
              onPressed: () async {
                var result = await sl<SigninUseCase>().call(
                  params: SigninUserReq(
                    email: _email.text,
                    password: _password.text,
                  ),
                );
                result.fold(
                  (l) => _showSnackbar(context, l.toString(), Colors.red),
                  (r) {
                    _showSnackbar(context, r.toString(), Colors.green);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                      (route) => false,
                    );
                  },
                );
              },
              height: 60,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.grey, height: 40)),
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
                Expanded(child: Divider(color: AppColors.grey, height: 40)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    AppVectors.google,
                    height: 40,
                    width: 40,
                  ),
                  onPressed: () async {
                    var result = await sl<SigninGoogleUseCase>().call();
                    result.fold(
                      (l) => _showSnackbar(context, l.toString(), Colors.red),
                      (r) => _showSnackbar(context, r.toString(), Colors.green),
                    );
                  },
                ),
                SizedBox(width: 30),
                IconButton(
                  icon: SvgPicture.asset(
                    AppVectors.apple,
                    height: 40,
                    width: 40,
                  ),
                  onPressed: () {
                    print('Apple Icon Pressed');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    ' Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
