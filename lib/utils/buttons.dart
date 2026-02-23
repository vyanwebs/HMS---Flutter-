import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  final bool isOutlined; // ⭐ NEW

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  final IconData? icon;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? fontSize;
  final bool iconIsLast;
  final double iconSize;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false, // ⭐ NEW

    this.backgroundColor = AppColors.info,
    this.textColor = Colors.white,
    this.borderColor,

    this.icon,
    this.borderRadius = 12,
    this.padding,
    this.fontSize = 12,
    this.iconIsLast = true,
    this.iconSize = 18,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final borderClr = widget.borderColor ?? widget.backgroundColor;

    final bgColor = widget.isOutlined
      ? (isHover ? borderClr.withValues(alpha: 0.08) : Colors.transparent)
      : (isHover ? widget.backgroundColor.withValues(alpha: 0.9) : widget.backgroundColor);

    final txtColor = widget.isOutlined ? borderClr : widget.textColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),

          /// ⭐ OUTLINE BORDER
          border: widget.isOutlined
              ? Border.all(color: borderClr, width: 1.4)
              : null,

          boxShadow: [
            if (isHover && !widget.isOutlined)
              BoxShadow(
                color: widget.backgroundColor.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: widget.isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: txtColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null && !widget.iconIsLast) ...[
                        Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color: txtColor
                        ),
                        const SizedBox(width: 8),
                      ],

                      Text(
                        widget.text,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w600,
                          color: txtColor,
                        ),
                      ),

                      if (widget.icon != null && widget.iconIsLast) ...[
                        const SizedBox(width: 8),
                        Icon(
                          widget.icon,
                          size: widget.iconSize,
                          color: txtColor
                        ),
                      ],
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}