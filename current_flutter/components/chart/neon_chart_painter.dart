import 'dart:math';
import 'package:flutter/material.dart';
import 'chart_point.dart';

class NeonChartPainter extends CustomPainter {
  final List<ChartPoint> data;
  final Color accentColor;
  final Color gridColor;
  final Color labelColor;
  final bool isDark;

  NeonChartPainter({
    required this.data,
    required this.accentColor,
    required this.gridColor,
    required this.labelColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double leftOffset = 45.0;
    const double bottomOffset = 25.0;
    final chartW = size.width - leftOffset;
    final chartH = size.height - bottomOffset;

    final widthStep = chartW / (data.length - 1);
    final maxVal = data.map((e) => e.value).reduce(max);
    final minVal = data.map((e) => e.value).reduce(min);
    final valRange = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    double getX(int i) => leftOffset + (i * widthStep);

    double getY(double v) {
      final double innerH = chartH - 20;
      return chartH - ((v - minVal) / valRange) * innerH - 10;
    }

    // ИСПРАВЛЕНО: Прямые, сочные HEX-цвета для шкал без прозрачности!
    final Paint gridPaint = Paint();
    gridPaint.color = isDark
        ? const Color(0xFF334155)  // Плотный Slate 700 для космоса
        : const Color(0xFF94A3B8); // Контрастный Slate 400 для белого
    gridPaint.strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      final double ratio = i / 3;
      final y = 10 + ratio * (chartH - 20);
      final val = maxVal - ratio * (maxVal - minVal);

      final p = TextPainter(
        text: TextSpan(
          text: '\$${(val / 1000).toStringAsFixed(1)}k',
          style: TextStyle(
            color: labelColor,
            fontSize: 10,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      p.layout();
      p.paint(canvas, Offset(5, y - 6));

      double currentX = leftOffset;
      while (currentX < size.width) {
        canvas.drawLine(
          Offset(currentX, y),
          Offset((currentX + 3).clamp(leftOffset, size.width), y),
          gridPaint,
        );
        currentX += 6;
      }
    }

    final int stepX = size.width < 500 ? 4 : 2;
    for (int i = 0; i < data.length; i += stepX) {
      final p = TextPainter(
        text: TextSpan(
          text: data[i].date,
          style: TextStyle(
            color: labelColor,
            fontSize: 9,
            fontFamily: 'JetBrains Mono',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      p.layout();
      p.paint(canvas, Offset(getX(i) - 15, chartH + 6));
    }

    final path = Path();
    final fillPath = Path();

    path.moveTo(getX(0), getY(data[0].value));
    fillPath.moveTo(getX(0), chartH);
    fillPath.lineTo(getX(0), getY(data[0].value));

    for (int i = 0; i < data.length - 1; i++) {
      final x1 = getX(i);
      final y1 = getY(data[i].value);
      final x2 = getX(i + 1);
      final y2 = getY(data[i + 1].value);

      final cx1 = x1 + (x2 - x1) / 2;
      final cy1 = y1;
      final cx2 = x1 + (x2 - x1) / 2;
      final cy2 = y2;

      path.cubicTo(cx1, cy1, cx2, cy2, x2, y2);
      fillPath.cubicTo(cx1, cy1, cx2, cy2, x2, y2);
    }

    fillPath.lineTo(getX(data.length - 1), chartH);
    fillPath.close();

    final Paint shaderPaint = Paint();
    shaderPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.45, 1.0],
      colors: [
        accentColor.withOpacity(isDark ? 0.35 : 0.18),
        accentColor.withOpacity(isDark ? 0.12 : 0.04),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(leftOffset, 0, chartW, chartH));
    canvas.drawPath(fillPath, shaderPaint);

    if (isDark) {
      final Paint blurPaint = Paint();
      blurPaint.style = PaintingStyle.stroke;
      blurPaint.strokeWidth = 4;
      blurPaint.color = accentColor.withOpacity(0.3);
      blurPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawPath(path, blurPaint);
    }

    final Paint linePaint = Paint();
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = 2;
    linePaint.color = accentColor;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant NeonChartPainter oldDelegate) => true;
}
