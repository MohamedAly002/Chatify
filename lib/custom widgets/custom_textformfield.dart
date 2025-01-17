import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomTextformField extends StatelessWidget {
  const CustomTextformField(
      {super.key,
      this.validator,
      this.hint,
      this.controller,
      this.backgroundColor= Colors.white,
      this.bordercolor= const Color(0xFF31C48D),
      this.keyboardtype = TextInputType.text,
      this.isObsecured = false,
      this.readonly = false,
      this.prefixIcon,
      this.suffixIcon,
      this.hasborder= true
      });
  final String? hint;
  final Validator? validator;
  final TextEditingController? controller;
  final TextInputType keyboardtype;
  final bool isObsecured;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final double borderRadius = 20;
final Color backgroundColor ;
final Color bordercolor ;
  final bool readonly;
  final bool hasborder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardtype,
          obscureText: isObsecured,
          readOnly: readonly,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 15),
            fillColor:backgroundColor,
            filled: true,
            border: hasborder
    ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: bordercolor),
      )
    : UnderlineInputBorder(
        borderSide: BorderSide(color:bordercolor),
      ),
  enabledBorder: hasborder
    ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: bordercolor),
      )
    : UnderlineInputBorder(
        borderSide: BorderSide(color: bordercolor),
      ),
  focusedBorder: hasborder
    ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: bordercolor),
      )
    : UnderlineInputBorder(
        borderSide: BorderSide(color: bordercolor),
      ),
  errorBorder: hasborder
    ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.red),
      )
    : const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
  focusedErrorBorder: hasborder
    ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.red),
      )
    : const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
)
          )
    );
  }
}
