// Модель одной верхней метрики (прилетает из Rust)
class RustStatMetric {
  final String key;
  final String value;
  final String changeLabel;
  final double? changePct;
  final bool isSuccessVariant;
  final bool isWalletIcon;

  const RustStatMetric({
    required this.key,
    required this.value,
    required this.changeLabel,
    this.changePct,
    required this.isSuccessVariant,
    required this.isWalletIcon,
  });
}

// Модель точки PnL для гистограмм и линейных графиков
class RustChartPoint {
  final int x;
  final double y;
  final String label;

  const RustChartPoint({
    required this.x,
    required this.y,
    required this.label,
  });
}

// Модель доли портфеля (для круговых диаграмм PieChart)
class RustShareMetric {
  final String name;
  final double value;
  final String percentStr;

  const RustShareMetric({
    required this.name,
    required this.value,
    required this.percentStr,
  });
}

// Модель строки сравнительного анализа роботов
class RustBotRowMetric {
  final String name;
  final String exchange;
  final String pair;
  final String balance;
  final String pnl;
  final String pnlPct;
  final String winRate;
  final String drawdown;
  final String trades;
  final bool isPositive;

  const RustBotRowMetric({
    required this.name,
    required this.exchange,
    required this.pair,
    required this.balance,
    required this.pnl,
    required this.pnlPct,
    required this.winRate,
    required this.drawdown,
    required this.trades,
    required this.isPositive,
  });
}

// Главный агрегированный объект аналитики экрана OSTS
class RustAnalyticsState {
  final List<RustStatMetric> topMetrics;
  final List<RustChartPoint> botPnL;
  final List<RustChartPoint> dailyPnL;
  final List<RustShareMetric> balanceDistribution;
  final List<RustShareMetric> exchangeDistribution;
  final List<RustChartPoint> strategyPerformance;
  final List<RustBotRowMetric> tableBots;

  const RustAnalyticsState({
    required this.topMetrics,
    required this.botPnL,
    required this.dailyPnL,
    required this.balanceDistribution,
    required this.exchangeDistribution,
    required this.strategyPerformance,
    required this.tableBots,
  });
}
