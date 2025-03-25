import 'package:flutter/material.dart';

class DisabledTextField extends StatelessWidget {
  const DisabledTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.hintText = '',
    this.label,
    this.showLockIcon = false, // Tambahan untuk opsi ikon kunci
  });

  final TextEditingController controller;
  final Widget? prefixIcon;
  final String hintText;
  final String? label;
  final bool showLockIcon; // Opsional: Menampilkan ikon kunci

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: false,
      style: TextStyle(
        color: Colors.grey[600], // Warna teks lebih soft dengan opacity
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]), // Warna hint lebih soft
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]), // Warna label lebih soft
        prefixIcon: showLockIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.lock_outline, color: Colors.grey),
                  const SizedBox(width: 5),
                  if (prefixIcon != null) prefixIcon!,
                ],
              )
            : prefixIcon,
        filled: false,
        // fillColor: Colors.grey[200], // Warna background lebih terang agar sesuai dengan gambar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!), // Border yang lebih soft
        ),
      ),
    );
  }
}
