import 'dart:math';
import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/'
    'chart/chart_point.dart';
import 'package:osts_mobile_app/components/'
    'chart/neon_chart_painter.dart';

class PortfolioChart extends StatefulWidget {
  const PortfolioChart({super.key});

  @override
  State<PortfolioChart> createState() =>
      _PortfolioChartState();
}

class _PortfolioChartState extends State<PortfolioChart> {
  final List<ChartPoint> _data = [];
  int? _hoveredIndex;
  Offset? _hoverPos;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    final days = [
      '03 мая', '04 мая', '05 мая', '06 мая',
      '07 мая', '08 мая', '09 мая', '10 мая',
      '11 мая', '12 мая', '13 мая', '14 мая',
      '15 мая', '16 мая', '17 мая', '18 мая'
    ];
    // ЖЕСТКИЙ ПРЕМИАЛЬНЫЙ РАСТУЩИЙ ТРЕНД
    final values = [
      9210.0, 9340.0, 9280.0, 9460.0,
      9520.0, 9410.0, 9630.0, 9580.0,
      9740.0, 9690.0, 9850.0, 9920.0,
      10120.0, 10050.0, 10260.0, 10480.0
    ];
    for (int i = 0; i < days.length; i++) {
      _data.add(ChartPoint(days[i], values[i]));
    }
  }

  void _updateHover(Offset localPos, Size size) {
    final chartW = size.width - 45;
    final chartX = localPos.dx - 45;
    if (chartX >= 0 && chartX <= chartW) {
      setState(() {
        _hoverPos = localPos;
        _hoveredIndex = ((chartX / chartW) *
            (_data.length - 1))
            .round()
            .clamp(0, _data.length - 1);
      });
    } else {
      _resetHover();
    }
  }

  void _resetHover() {
    setState(() {
      _hoveredIndex = null;
      _hoverPos = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPos = _data.last.value >= _data.first.value;
    final isDark = AppTheme.isDark(context);
    final accent =
    isPos ? AppTheme.success : AppTheme.destructive;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bd(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Динамика портфеля',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.txt(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Последние 30 дней',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.txtMuted(context),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final chartW = constraints.maxWidth - 45;
              final widthStep = chartW / (_data.length - 1);

              double? focusX;
              double? focusY;

              if (_hoveredIndex != null) {
                focusX = 45 + (_hoveredIndex! * widthStep);
                final maxVal =
                _data.map((e) => e.value).reduce(max);
                final minVal =
                _data.map((e) => e.value).reduce(min);
                final valRange = (maxVal - minVal) == 0
                    ? 1.0
                    : (maxVal - minVal);
                focusY = 195 -
                    ((_data[_hoveredIndex!].value - minVal) /
                        valRange) *
                        195;
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: GestureDetector(
                      // ИСПРАВЛЕНО: Заменили Size constraints на реальный context box
                      onPanUpdate: (details) {
                        final RenderBox box = context
                            .findRenderObject() as RenderBox;
                        _updateHover(
                          details.localPosition,
                          box.size,
                        );
                      },
                      onPanEnd: (_) => _resetHover(),
                      child: MouseRegion(
                        onHover: (event) {
                          final RenderBox box = context
                              .findRenderObject() as RenderBox;
                          _updateHover(
                            event.localPosition,
                            box.size,
                          );
                        },
                        onExit: (_) => _resetHover(),
                        // ИСПРАВЛЕНО: Аппаратная защита от вылетов линий Безье
                        child: ClipRect(
                          child: CustomPaint(
                            painter: NeonChartPainter(
                              data: _data,
                              accentColor: accent,
                              gridColor: AppTheme.bd(context),
                              labelColor: AppTheme.txtMuted(context),
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (focusX != null)
                    Positioned(
                      left: focusX,
                      top: 0,
                      bottom: 25,
                      child: Container(
                        width: 1,
                        color: accent.withOpacity(0.2),
                      ),
                    ),
                  if (focusX != null && focusY != null)
                    Positioned(
                      left: focusX - 6,
                      top: focusY - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(
                                isDark ? 0.6 : 0.4,
                              ),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  if (_hoveredIndex != null &&
                      _hoverPos != null &&
                      focusX != null)
                    _buildTooltipOverlay(focusX, isDark),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTooltipOverlay(double pointX, bool isDark) {
    final box = context.findRenderObject() as RenderBox;
    final pointY = _hoverPos!.dy.clamp(40.0, 160.0);
    final point = _data[_hoveredIndex!];

    return Positioned(
      left: (pointX - 60).clamp(50.0, box.size.width - 130),
      top: (pointY - 75).clamp(0.0, 120.0),
      child: IgnorePointer(
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.bd(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                point.date,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.txtMuted(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '\$${point.value.toLocale()}',
                style: AppTheme.monoStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.txt(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
