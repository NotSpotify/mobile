import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/common/widgets/input/basic_textfield.dart';
import 'package:notspotify/common/widgets/appbar/basic_app_bar.dart'; // 👈 Thêm dòng này
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/data/models/auth/create_user_req.dart';
import 'package:notspotify/domain/usecases/auth/signin_google.dart';
import 'package:notspotify/domain/usecases/auth/signup.dart';
import 'package:notspotify/service_locator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isObscured = true;
  bool _isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ), // 👈 AppBar ở đây
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            _SignUpText(),
            SizedBox(height: 20),
            _IntroText(),
            SizedBox(height: 30),
            _FullNameField(),
            SizedBox(height: 5),
            EmailField(),
            SizedBox(height: 5),
            _PasswordField(),
            SizedBox(height: 5),
            _ForgotPasswordBtn(),
            BasicAppButton(
              color: AppColors.primary,
              title: 'Sign Up',
              onPressed: () async {
                var result = await sl<SignupUseCase>().call(
                  params: CreateUserReq(
                    fullName: _fullName.text.trim(),
                    email: _email.text.trim(),
                    password: _password.text,
                    imageUrl:
                        'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                  ),
                );

                result.fold(
                  (l) => _showSnackbar(context, l.toString(), Colors.red),
                  (r) => _showSnackbar(context, r.toString(), Colors.green),
                );
              },
              height: 60,
            ),
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.grey, thickness: 1)),
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
                Expanded(child: Divider(color: AppColors.grey, thickness: 1)),
              ],
            ),
            SizedBox(height: 8),
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
                SizedBox(width: 40),
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
            SizedBox(height: 10),
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
                  },
                  child: Text(
                    ' Sign In',
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

  Align _ForgotPasswordBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text('Forgot Password?'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black54,
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  BasicTextfield _PasswordField() {
    return BasicTextfield(
      controller: _password,
      hintText: 'Enter Password',
      isPassword: _isPassword,
      isObscured: _isObscured,
      suffixIcon: IconButton(
        iconSize: 20,
        color: Colors.black54,
        padding: EdgeInsets.all(5),
        icon: _isObscured ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
            _isPassword = !_isPassword;
          });
        },
      ),
    );
  }

  BasicTextfield EmailField() =>
      BasicTextfield(hintText: "Enter Email", controller: _email);

  BasicTextfield _FullNameField() =>
      BasicTextfield(hintText: "Enter Full Name", controller: _fullName);

  Text _IntroText() {
    return Text(
      'Sign up to create a new account.',
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  Text _SignUpText() {
    return Text(
      'Sign Up',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.black,
      ),
    );
  }
}
