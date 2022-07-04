import 'package:flutter/material.dart';

class MaterialYouTextFeild extends StatelessWidget {
  const MaterialYouTextFeild({
    Key? key,
    this.controller,
    this.keyboardType = TextInputType.none,
    this.validator,
    this.decoration,
    this.hintText,
    this.maxLength,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText ?? '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
          ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
