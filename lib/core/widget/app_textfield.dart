import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.hintText = 'Masukkan teks',
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.label,
    this.onSubmitted,
    this.enabled,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
  });

  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool readOnly;
  final void Function()? onTap;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? label;
  final void Function(String)? onSubmitted;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      maxLength: maxLength,
      enabled: enabled,
      style: TextStyle(
        color: enabled == false ?  Colors.black45 : null,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        counterText: '',
        hintText: hintText,
        labelText: label,
        labelStyle: TextStyle(
          color: enabled == false ? Colors.black54 : null,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black45),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
