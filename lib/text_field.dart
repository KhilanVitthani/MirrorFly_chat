import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField getTextField({
  String? hintText,
  String? labelText,
  TextEditingController? textEditingController,
  Widget? prefixIcon,
  double? borderRadius,
  Widget? suffixIcon,
  double? size = 70,
  Widget? suffix,
  Color? borderColor,
  Color? fillColor,
  bool isFilled = false,
  Color? labelColor,
  TextInputType textInputType = TextInputType.name,
  TextInputAction textInputAction = TextInputAction.next,
  bool textVisible = false,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLine = 1,
  String errorText = "",
  Function(String)? onChange,
  FormFieldValidator<String>? validation,
  double fontSize = 15,
  double hintFontSize = 14,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextFormField(
    controller: textEditingController,
    obscureText: textVisible,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    textCapitalization: textCapitalization,
    cursorColor: Colors.black,
    readOnly: readOnly,
    validator: validation,
    onTap: onTap,
    maxLines: maxLine,
    onChanged: onChange,
    style: TextStyle(
      fontSize: 15,
    ),
    decoration: InputDecoration(
      fillColor: fillColor ?? Colors.grey[200],
      filled: isFilled,
      labelText: labelText,
      labelStyle: TextStyle(
          color: labelColor ?? Colors.grey[200], fontWeight: FontWeight.w600),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor ?? Colors.grey[200]!),
        borderRadius:
            BorderRadius.circular((borderRadius == null) ? 5 : borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular((borderRadius == null) ? 5 : borderRadius),
        borderSide: BorderSide(color: borderColor ?? Colors.grey[200]!),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular((borderRadius == null) ? 5 : borderRadius),
        borderSide: BorderSide(color: borderColor ?? Colors.grey[200]!),
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular((borderRadius == null) ? 5 : borderRadius),
      ),
      contentPadding: EdgeInsets.only(
        left: 20,
        right: 10,
        bottom: size! / 2, // HERE THE IMPORTANT PART
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorMaxLines: 2,
      errorText: (isNullEmptyOrFalse(errorText)) ? null : errorText,
      hintText: hintText,
      hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey.shade500),
    ),
  );
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}
