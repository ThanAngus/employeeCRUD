import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomButton({
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.padding,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: buttonColor ?? Theme.of(context).primaryColor,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          buttonText,
          style: textStyle ?? Theme.of(context).textTheme.bodySmall!.copyWith(
                color: textColor ?? Colors.white,
                fontSize: 14,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
