import 'package:camera_app/shared_widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? textStyle;
  final InputDecoration? inputDecoration;
  final void Function(String)? onChanged;
  final VoidCallback? ontap;
  final VoidCallback? onEdittingComplete;

  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;

  final bool obscureText;

  final String? errorMessage;

  final FocusNode? focusNode;

  final TextEditingController? controller;

  final bool enabled;

  //final List<TextInputFormatter>? inputFormatters;

  final bool enableInteractiveSelection;

  final double borderRadius;

  final Color fillColor;

  final Widget? suffixIcon;

  final Widget? prefixIcon;
  final Widget? label;

  final String? helperText;

  final String? labelText;

  final bool isTransparentBorder;

  final Color? textColor;

  final int? maxLines;

  final TextCapitalization textCapitalization;

  final Color borderColor;

  final int? maxLength;

  final List<TextInputFormatter>? textInputFormat;
  final MaxLengthEnforcement? maxLengthEnforcement;

  CustomTextField(
      {this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.contentPadding,
      this.onChanged,
      this.keyboardType,
      this.errorMessage,
      this.controller,
      this.focusNode,
      this.borderRadius = 6.0,
      this.enabled = true,
      // this.inputFormatters,
      this.ontap,
      this.onEdittingComplete,
      this.labelText,
      this.textInputFormat,
      this.maxLengthEnforcement,
      this.maxLines,
      this.helperText,
      this.enableInteractiveSelection = true,
      this.obscureText = false,
      this.fillColor = Colors.white,
      this.isTransparentBorder = false,
      this.textCapitalization = TextCapitalization.none,
      this.borderColor = Colors.grey,
      this.textColor,
      this.maxLength,
      this.label,
      this.textStyle,
      this.inputDecoration});

  @override
  Widget build(BuildContext context) {
    final sh = sHeight(context);
    final sw = sWidth(context);

    return TextField(
      enableInteractiveSelection: enableInteractiveSelection,
      enabled: enabled,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: textCapitalization,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      maxLengthEnforcement: maxLengthEnforcement,
      inputFormatters: textInputFormat,
      maxLength: maxLength,
      style: textStyle ??
          Theme.of(context).textTheme.headline5!.copyWith(fontSize: sh(13)),
      decoration: inputDecoration ??
          InputDecoration(
            labelText: labelText,
            label: label,
            //  floatingLabelBehavior: FloatingLabelBehavior.never,

            helperText: helperText,
            errorText: errorMessage == "" || errorMessage == null
                ? null
                : errorMessage,
            counterText: "",
            errorStyle: TextStyle(fontSize: sh(12)),
            contentPadding: contentPadding ??
                EdgeInsets.fromLTRB(sw(12), sh(20), sw(12), sh(20)),
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode ? Colors.white : Colors.grey),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        isTransparentBorder ? Colors.transparent : borderColor,
                    width: 1),
                borderRadius: BorderRadius.circular(borderRadius)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color:
                        isTransparentBorder ? Colors.transparent : borderColor,
                    width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color:
                        isTransparentBorder ? Colors.transparent : borderColor,
                    width: 2)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        isTransparentBorder ? Colors.transparent : borderColor,
                    width: 1),
                borderRadius: BorderRadius.circular(borderRadius)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        isTransparentBorder ? Colors.transparent : Colors.red,
                    width: 1)),
            filled: true,
            fillColor: fillColor,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
      onChanged: onChanged,
      onTap: ontap,
      onEditingComplete: onEdittingComplete,
    );
  }
}
