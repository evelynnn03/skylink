import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/variables.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool?
      obscureText; // Only for password: to hide the text entered, eg:  abc -> ...
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool validate;

  const MyTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.obscureText,
    required this.keyboardType,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
    this.validate = true,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        validator: widget.validate
            ? (value) {
                if (widget.validator != null) {
                  return widget.validator!(value);
                }
                if (value!.isEmpty) {
                  return 'Please enter ${widget.labelText}';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: Variables.hintStyle(context),
          hintText: widget.hintText,
          hintStyle: Variables.hintStyle(context),
          helperText: widget.helperText,
          helperStyle: Variables.hintStyle(context),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Variables.bottomNavIcons)
              : null,

          // Visibility of password field
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    }
                  },
                  child: Icon(
                    widget.obscureText ?? false
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Variables.bottomNavIcons,
                    size: Variables.responsiveIconSize(context, 23),
                  ),
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Variables.primaryColor, width: 3),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),

          fillColor: Colors.white,
          filled: true,

          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 3),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),

          enabled: widget.enabled,
        ),
        inputFormatters: widget.inputFormatters,
        onChanged: (text) {
          if (widget.onChanged != null) {
            widget.onChanged!(text.toUpperCase());
          }
        },
      ),
    );
  }
}
