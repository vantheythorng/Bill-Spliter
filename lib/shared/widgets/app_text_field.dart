import 'package:flutter/material.dart';

/// A thin wrapper over [TextFormField] that standardises the app's text inputs:
/// it builds the [InputDecoration] from [label]/[hint] and exposes only the
/// props actually used across the app, so every field looks and behaves the
/// same. Use the [AppTextField.amount] constructor for decimal money/number
/// inputs — it wires up the numeric keyboard for you.
///
/// Works inside or outside a [Form]; pass a [validator] to participate in form
/// validation.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.isDense = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  /// A numeric input for money/decimal amounts — sets a decimal keyboard.
  const AppTextField.amount({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.isDense = false,
    this.prefixIcon,
    this.suffixIcon,
  })  : keyboardType = const TextInputType.numberWithOptions(decimal: true),
        textCapitalization = TextCapitalization.none;

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final bool isDense;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    onTapOutside: (event) {
     FocusScope.of(context).unfocus();
    },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: isDense,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
