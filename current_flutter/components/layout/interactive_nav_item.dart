import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_theme.dart';

class InteractiveNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String path;
  final String currentPath;
  final bool isCollapsed;

  const InteractiveNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.path,
    required this.currentPath,
    required this.isCollapsed,
  });

  @override
  State<InteractiveNavItem> createState() =>
      _InteractiveNavItemState();
}

class _InteractiveNavItemState
    extends State<InteractiveNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.path == '/'
        ? widget.currentPath == '/'
        : widget.currentPath.startsWith(widget.path);

    Color contentColor = AppTheme.txtMuted(context);
    if (isActive) {
      contentColor = AppTheme.brand(context);
    } else if (_isHovered) {
      contentColor = AppTheme.txt(context);
    }

    Color bgColor = Colors.transparent;
    if (isActive) {
      bgColor = AppTheme.brand(context).withOpacity(0.1);
    } else if (_isHovered) {
      bgColor = AppTheme.isDark(context)
          ? const Color(0xFF1E293B).withOpacity(0.4)
          : const Color(0xFFE2E8F0).withOpacity(0.6);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor:
            AppTheme.brand(context).withOpacity(0.2),
            highlightColor:
            AppTheme.brand(context).withOpacity(0.08),
            onTap: () => context.go(widget.path),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: contentColor,
                  ),
                  // ИСПРАВЛЕНО: Visibility намертво убирает текст из дерева
                  // при constraints=23px, полностью ликвидируя overflow!
                  Visibility(
                    visible: !widget.isCollapsed,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: contentColor,
                            fontSize: 14,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
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
