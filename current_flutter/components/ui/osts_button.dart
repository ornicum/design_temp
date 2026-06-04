import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';

enum OstsButtonVariant { primary, outline }

class OstsButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final OstsButtonVariant variant;

  const OstsButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.variant = OstsButtonVariant.primary,
  });

  @override
  State<OstsButton> createState() => _OstsButtonState();
}

class _OstsButtonState extends State<OstsButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final brand = AppTheme.brand(context);
    final isPrimary = widget.variant == OstsButtonVariant.primary;

    Color bgColor;
    if (isPrimary) {
      bgColor = _isHovered ? brand.withOpacity(0.92) : brand;
    } else {
      bgColor = _isHovered ? brand.withOpacity(0.12) : Colors.transparent;
    }

    final bdColor = isPrimary ? Colors.transparent : brand;
    final defaultPrimaryText = isDark ? AppTheme.darkBg : Colors.white;
    final contentColor = isPrimary ? defaultPrimaryText : (_isHovered ? brand : brand.withOpacity(0.8));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered && isPrimary ? [
            BoxShadow(
              color: brand.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Material(
          type: MaterialType.canvas,
          color: bgColor, // Цвет фона СТРОГО в Material для работы волны
          shape: RoundedRectangleBorder(
            side: BorderSide(color: bdColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: isPrimary ? defaultPrimaryText.withOpacity(0.2) : brand.withOpacity(0.25),
            highlightColor: brand.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: contentColor, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
