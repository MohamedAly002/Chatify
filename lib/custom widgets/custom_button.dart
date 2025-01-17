import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
   final void Function()? onPressed;
   final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomButton({super.key, required this.text,  this.onPressed,this.fontSize = 18, // Default font size
    this.padding = const EdgeInsets.symmetric(horizontal: 80, vertical: 15),});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: padding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    backgroundColor: const Color(0xFF31C48D),
                  ),
                  child:  Text(text, style:  TextStyle(color: Colors.white,fontSize: fontSize)),
                );
  }
}