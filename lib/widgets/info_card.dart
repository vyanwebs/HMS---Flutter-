import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget leading;
  final Widget? trailing;
  final Color backgroundColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.trailing,
    this.buttonText,
    this.onPressed,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 500;

        return Container(
          width: isDesktop ? 280 : 100,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 20 : 14,
            vertical: isDesktop ? 16 : 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              const SizedBox(width: 12),

              // text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: isDesktop ? 15 : 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing!,
                        ]
                      ],
                    ),
                
                    const SizedBox(height: 4),
                
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isDesktop ? 12.5 : 11.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                
                    if (buttonText != null) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff4AA3DF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                          ),
                          onPressed: onPressed,
                          child: Text(
                            buttonText!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
