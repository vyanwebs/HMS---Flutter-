import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
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
    this.backgroundColor = AppColors.info,
    this.textColor = Colors.white,
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
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isHover
            ? widget.backgroundColor.withValues(alpha: 0.9)
            : widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (isHover)
              BoxShadow(
                color: widget.backgroundColor.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )
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
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null && !widget.iconIsLast) ...[
                      Icon(widget.icon, size: widget.iconSize, color: widget.textColor),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w600,
                        color: widget.textColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (widget.icon != null && widget.iconIsLast) ...[
                      const SizedBox(width: 8),
                      Icon(widget.icon, size: widget.iconSize, color: widget.textColor),
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
