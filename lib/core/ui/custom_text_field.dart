import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;
  final CustomText hint;
  final String? Function(String?) validator;
  final IconData? icon;
  final ValueChanged<String>? onChanged;

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
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: field.hasError ? 2 : 0,
                  color: field.hasError
                      ? const Color(0xFFE11D48)
                      : const Color(0xFFF7F7F7),
                ),
              ),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Icon(widget.icon, size: 18, color: const Color(0xFF717171)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
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
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Amicons.remix_error_warning,
                          size: 14,
                          color: Color(0xFFE11D48),
                        ),
                        const SizedBox(width: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            field.errorText ?? '',
                            color: const Color(0xFFE11D48),
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
