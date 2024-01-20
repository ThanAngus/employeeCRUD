import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixWidget;
  final VoidCallback? onPressed;
  final TextEditingController? textEditingController;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final bool? readOnly;
  final TextStyle? textStyle;

  const CustomTextFormField({
    required this.hint,
    required this.prefixIcon,
    this.textStyle,
    this.onPressed,
    this.suffixWidget,
    this.textEditingController,
    this.initialValue,
    this.validator,
    this.readOnly,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyle ?? Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
      onTap: onPressed,
      readOnly: readOnly ?? false,
      controller: textEditingController,
      initialValue: initialValue,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade500,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red.shade500,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red.shade500,
          ),
        ),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.black45,
              fontSize: 14,
            ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: suffixWidget,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        constraints: const BoxConstraints.tightFor(
          height: 42,
        ),
      ),
    );
  }
}
