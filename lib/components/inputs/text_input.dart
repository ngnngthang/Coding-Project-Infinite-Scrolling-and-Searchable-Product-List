import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.onChanged,
    this.hintText,
    this.prefix,
    this.suffix,
    this.controller,
    this.focusNode,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Colors.black54,
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: Colors.black38),
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black45),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black87),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
