import '../models/analytics_models.dart';

class AnalyticsMockRepository {
  static RustAnalyticsState getMockState() {
    return const RustAnalyticsState(
      topMetrics: [
        RustStatMetric(key: 'analytics_total_balance', value: '\$26 940', changeLabel: 'Вложено: \$24 500', isSuccessVariant: false, isWalletIcon: true),
        RustStatMetric(key: 'analytics_total_pnl', value: '+\$2 440.00', changeLabel: '+9.0%', changePct: 9.0, isSuccessVariant: true, isWalletIcon: false),
        RustStatMetric(key: 'analytics_total_trades', value: '1 353', changeLabel: 'Прибыльных: 812', isSuccessVariant: false, isWalletIcon: false),
        RustStatMetric(key: 'analytics_avg_winrate', value: '58.5%', changeLabel: 'Стабильно', isSuccessVariant: true, isWalletIcon: false),
        RustStatMetric(key: 'analytics_trading_volume', value: '\$2.4M', changeLabel: '1353 сделки', isSuccessVariant: false, isWalletIcon: false),
        RustStatMetric(key: 'analytics_active_bots', value: '2', changeLabel: 'Всего: 5', isSuccessVariant: false, isWalletIcon: false),
      ],
      botPnL: [
        RustChartPoint(x: 0, y: 2840.00, label: 'BTC Grid Premium'),
        RustChartPoint(x: 1, y: 150.00, label: 'ETH DCA Safe'),
        RustChartPoint(x: 2, y: -150.00, label: 'SOL Momentum'),
      ],
      dailyPnL: [
        RustChartPoint(x: 0, y: 45.0, label: '24.05'),
        RustChartPoint(x: 1, y: -20.0, label: '26.05'),
        RustChartPoint(x: 2, y: 110.0, label: '28.05'),
        RustChartPoint(x: 3, y: 75.0, label: '30.05'),
        RustChartPoint(x: 4, y: -55.0, label: '01.06'),
        RustChartPoint(x: 5, y: 130.0, label: '03.06'),
        RustChartPoint(x: 6, y: 90.0, label: '05.06'),
      ],
      balanceDistribution: [
        RustShareMetric(name: 'BTC Grid Premium', value: 12840.0, percentStr: '80.3%'),
        RustShareMetric(name: 'ETH DCA Safe', value: 3150.0, percentStr: '19.7%'),
      ],
      exchangeDistribution: [
        RustShareMetric(name: 'BINANCE', value: 16840.0, percentStr: '84.2%'),
        RustShareMetric(name: 'BYBIT', value: 3150.0, percentStr: '15.8%'),
      ],
      strategyPerformance: [
        RustChartPoint(x: 0, y: 2840.0, label: 'Grid'),
        RustChartPoint(x: 1, y: 150.0, label: 'DCA'),
      ],
      tableBots: [
        RustBotRowMetric(name: 'BTC Grid Premium', exchange: 'BINANCE', pair: 'BTC/USDT', balance: '\$12 840', pnl: '+\$2 840.00', pnlPct: '+28.4%', winRate: '68.5%', drawdown: '4.2%', trades: '582', isPositive: true),
        RustBotRowMetric(name: 'ETH DCA Safe', exchange: 'BYBIT', pair: 'ETH/USDT', balance: '\$3 150', pnl: '+\$150.00', pnlPct: '+5.0%', winRate: '71.0%', drawdown: '2.1%', trades: '124', isPositive: true),
        RustBotRowMetric(name: 'SOL Momentum', exchange: 'OKX', pair: 'SOL/USDT', balance: '\$4 850', pnl: '-\$150.00', pnlPct: '-3.0%', winRate: '52.1%', drawdown: '6.8%', trades: '92', isPositive: false),
        RustBotRowMetric(name: 'XRP Reversal Pro', exchange: 'BINANCE', pair: 'XRP/USDT', balance: '\$4 000', pnl: '\$0.00', pnlPct: '0.0%', winRate: '61.2%', drawdown: '3.9%', trades: '310', isPositive: true),
        RustBotRowMetric(name: 'ADA Breakout Multi', exchange: 'BYBIT', pair: 'ADA/USDT', balance: '\$2 100', pnl: '-\$400.00', pnlPct: '-16.0%', winRate: '40.0%', drawdown: '18.2%', trades: '45', isPositive: false),
      ],
    );
  }
}
