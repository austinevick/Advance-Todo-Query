import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final String? text;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textColor;
  final List<Color>? gradient;
  final BorderSide? borderSide;
  final double? radius;
  final bool isLoading;
  final BorderRadius? borderRadius;
  const CustomButton(
      {Key? key,
      this.onPressed,
      this.textColor,
      this.text,
      this.color,
      this.child,
      this.width = double.infinity,
      this.height,
      this.gradient = const [Colors.transparent, Colors.transparent],
      this.borderSide,
      this.radius = 50,
      this.borderRadius,
      this.isLoading = false,
      this.onLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading ? true : false,
      child: SizedBox(
        height: height ?? 60,
        width: width,
        child: MaterialButton(
          onLongPress: onLongPressed,
          elevation: 0,
          onPressed: onPressed,
          color: color,
          shape: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(radius!),
              borderSide: borderSide ?? BorderSide.none),
          child: child ??
              Text(text!,
                  style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
