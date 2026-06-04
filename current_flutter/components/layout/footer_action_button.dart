import 'package:flutter/material.dart';
import '../../app_theme.dart';

class FooterActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isDestructive;
  final VoidCallback onTap;

  const FooterActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isCollapsed,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  State<FooterActionButton> createState() =>
      _FooterActionButtonState();
}

class _FooterActionButtonState
    extends State<FooterActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color contentColor = AppTheme.txtMuted(context);
    Color bgColor = Colors.transparent;

    if (widget.isDestructive && _isHovered) {
      contentColor = AppTheme.destructive;
      bgColor = AppTheme.destructive.withOpacity(0.1);
    } else if (_isHovered) {
      contentColor = AppTheme.txt(context);
      bgColor = AppTheme.isDark(context)
          ? const Color(0xFF1E293B).withOpacity(0.4)
          : const Color(0xFFE2E8F0).withOpacity(0.6);
    }

    final MainAxisAlignment alignment = widget.isCollapsed
        ? MainAxisAlignment.center
        : MainAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: widget.isDestructive
                ? AppTheme.destructive.withOpacity(0.15)
                : AppTheme.brand(context).withOpacity(0.1),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: alignment,
                children: [
                  Icon(widget.icon, size: 20, color: contentColor),
                  if (!widget.isCollapsed) ...[
                    const SizedBox(width: 12),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 14,
                        // ИСПРАВЛЕНО: Корректный вес шрифта
                        fontWeight: FontWeight.w500,
                      ),
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
