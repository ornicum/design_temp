import 'package:flutter/material.dart';
import '../app_theme.dart';

enum StatCardVariant { defaultVariant, success, danger }

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final double? change;
  final String? changeLabel;
  final IconData? icon;
  final StatCardVariant variant;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.changeLabel,
    this.icon,
    this.variant = StatCardVariant.defaultVariant,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPos = (widget.change ?? 0) >= 0;
    final isDark = AppTheme.isDark(context);
    final double width = MediaQuery.of(context).size.width;
    final double pad = width < 600 ? 12.0 : 20.0;

    Color valColor = AppTheme.txt(context);
    if (widget.variant == StatCardVariant.success) {
      valColor = AppTheme.success;
    } else if (widget.variant == StatCardVariant.danger) {
      valColor = AppTheme.destructive;
    }

    final Color borderHoverColor = isDark
        ? AppTheme.brand(context).withOpacity(0.3)
        : const Color(0xFF64748B);

    final List<BoxShadow>? currentShadow = _isHovered
        ? [
      isDark
          ? BoxShadow(
        color: AppTheme.brand(context)
            .withOpacity(0.05),
        blurRadius: 16,
        spreadRadius: 1,
      )
          : BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ]
        : null;

    final Color iconBgColor = isDark
        ? AppTheme.brand(context)
        .withOpacity(_isHovered ? 0.2 : 0.1)
        : AppTheme.brand(context)
        .withOpacity(_isHovered ? 0.15 : 0.08);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // ИСПРАВЛЕНО: Убрали паддинг отсюда, чтобы InkWell прижался к краям
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? borderHoverColor
                : AppTheme.bd(context),
            width: 1.0,
          ),
          boxShadow: currentShadow,
        ),
        // ИСПРАВЛЕНО: Иерархия перевернута. InkWell теперь на самом верху!
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            splashColor:
            AppTheme.brand(context).withOpacity(0.12),
            onTap: () {},
            // ИСПРАВЛЕНО: Паддинг перенесен внутрь кликабельной зоны
            child: Padding(
              padding: EdgeInsets.all(pad),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                            width < 600 ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.txtMuted(
                              context,
                            ),
                          ),
                        ),
                      ),
                      if (widget.icon != null &&
                          width > 350)
                        Container(
                          padding:
                          const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius:
                            BorderRadius.circular(
                              6,
                            ),
                          ),
                          child: AnimatedScale(
                            scale: _isHovered ? 1.12 : 1.0,
                            duration: const Duration(
                              milliseconds: 200,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 14,
                              color: AppTheme.brand(
                                context,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.value,
                          style: TextStyle(
                            fontSize: width < 600
                                ? 18
                                : 22,
                            color: valColor,
                            fontWeight:
                            FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (widget.change != null) ...[
                          const WidgetSpan(
                            alignment: PlaceholderAlignment
                                .baseline,
                            baseline:
                            TextBaseline.alphabetic,
                            child: SizedBox(width: 6),
                          ),
                          TextSpan(
                            text: '${isPos ? "▲" : "▼"} '
                                '${widget.change!.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                              FontWeight.bold,
                              color: isPos
                                  ? AppTheme.success
                                  : AppTheme
                                  .destructive,
                            ),
                          ),
                        ],
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.changeLabel != null)
                    Text(
                      widget.changeLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.txtMuted(
                          context,
                        ),
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
