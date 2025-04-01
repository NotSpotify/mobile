import 'package:flutter/material.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';

class BasicTextfield extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? isPassword;
  final bool? isObscured;
  final Widget? suffixIcon;
  const BasicTextfield({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.keyboardType,
    this.controller,
    this.isPassword,
    this.isObscured,
    this.suffixIcon,
  });

  @override
  State<BasicTextfield> createState() => _BasicTextfieldState();
}

class _BasicTextfieldState extends State<BasicTextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ?? false,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.darkNav),
          ),
          hintText: widget.hintText,
          labelText: widget.labelText,
          errorText: widget.errorText,
          labelStyle: TextStyle(color: Colors.black54),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
