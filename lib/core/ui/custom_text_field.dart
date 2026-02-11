import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.validator,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    required this.hint,
    this.controller,
    this.icon,
    this.onChanged,
    this.showErrorMsg = true,
    this.trailingText,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;
  final CustomText hint;
  final String? Function(String?) validator;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final bool showErrorMsg;
  final String? trailingText;
  final TextAlign textAlign;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  bool _listenerAttached = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (field) {
        if (!_listenerAttached) {
          _listenerAttached = true;
          _focusNode.addListener(() {
            if (!_focusNode.hasFocus) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) field.validate();
              });
            }
          });
        }

        if (widget.controller != null &&
            field.value != widget.controller!.text) {
          field.didChange(widget.controller!.text);
        }

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                color: customColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: field.hasError ? 2 : 0,
                  color: field.hasError
                      ? customColors.destructive
                      : customColors.border,
                ),
              ),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: 18,
                      color: customColors.textFieldPlaceholder,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      textAlign: widget.textAlign,
                      focusNode: _focusNode,
                      controller: widget.controller,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged:
                          widget.onChanged ?? (value) => field.didChange(value),
                      keyboardType: widget.keyboardType,
                      minLines: widget.minLines,
                      maxLines: widget.maxLines,
                      decoration: InputDecoration(
                        hint: widget.hint,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      style: TextStyle(color: customColors.onSecondary),
                    ),
                  ),
                  if (widget.trailingText != null)
                    CustomText(
                      widget.trailingText!,
                      fontSize: 12,
                      color: customColors.textFieldPlaceholder,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
            ),
            if (field.hasError && widget.showErrorMsg)
              Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Amicons.remix_error_warning,
                          size: 14,
                          color: customColors.destructive,
                        ),
                        const SizedBox(width: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            field.errorText ?? '',
                            color: customColors.destructive,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .slideY(begin: -0.5, end: 0.0, curve: Curves.easeOut)
                  .fadeIn(duration: 300.ms),
          ],
        );
      },
    );
  }
}
