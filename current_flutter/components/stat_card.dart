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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // ИСПРАВЛЕНИЕ: Никакой фиксированной высоты. Полная свобода для контента.
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? borderHoverColor : AppTheme.bd(context),
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Первая строка: Заголовок и Иконка
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: width < 600 ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.txtMuted(context),
                          ),
                        ),
                      ),
                      if (widget.icon != null && width > 350)
                        Icon(widget.icon, size: 14, color: AppTheme.brand(context)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2. Вторая строка: Баланс / Значение + Проценты
                  _buildValueBlock(width, valColor),

                  // 3. Третья строка: Подзаголовок (или его невидимый двойник-заглушка)
                  const SizedBox(height: 4),
                  _buildFooterLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueBlock(double width, Color valColor) {
    final isPos = (widget.change ?? 0) >= 0;

    // Если процентов нет, рендерим невидимую заглушку для сохранения единой высоты строки
    final Widget changeWidget = widget.change != null
        ? Text(
      ' ${isPos ? "▲" : "▼"} ${widget.change!.toStringAsFixed(0)}%',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isPos ? AppTheme.success : AppTheme.destructive,
      ),
    )
        : const Opacity(
      opacity: 0,
      child: Text(' ▲ 0%', style: TextStyle(fontSize: 11)),
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: widget.value,
            style: TextStyle(
              fontSize: width < 600 ? 18 : 22,
              color: valColor,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: changeWidget,
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterLabel() {
    // Сохраняем физическое место под третью строчку, даже если лейбла нет
    if (widget.changeLabel != null) {
      return Text(
        widget.changeLabel!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 11, color: AppTheme.txtMuted(context)),
      );
    }
    return const Opacity(
      opacity: 0,
      child: Text('Placeholder', style: TextStyle(fontSize: 11)),
    );
  }
}
