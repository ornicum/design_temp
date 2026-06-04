import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/pages/bots/bots_filters.dart';
import 'package:osts_mobile_app/pages/bots/bots_list_view.dart';
import 'package:osts_mobile_app/pages/bots/create_bot_dialog.dart';
// Абсолютный импорт нашей новой глобальной UI кнопки
import 'package:osts_mobile_app/components/ui/osts_button.dart';

class BotsPage extends StatefulWidget {
  const BotsPage({super.key});

  @override
  State<BotsPage> createState() => _BotsPageState();
}

class _BotsPageState extends State<BotsPage> {
  String _activeTab = 'all';
  String _searchQuery = '';

  final List<Bot> _allBots = [
    Bot(
      id: '1',
      name: 'BTC Grid Premium',
      description: 'Сетка ордеров в диапазоне',
      strategy: 'grid',
      status: 'active',
      exchange: 'binance',
      tradingPair: 'BTC/USDT',
      initialCapital: 10000.0,
      currentBalance: 12840.0,
      profitLoss: 2840.0,
      profitLossPercent: 28.4,
      riskLevel: 'medium',
      totalTrades: 582,
      winRate: 68.5,
      maxDrawdown: 4.2,
    ),
    Bot(
      id: '2',
      name: 'ETH DCA Safe',
      description: 'Регулярные покупки',
      strategy: 'dca',
      status: 'active',
      exchange: 'bybit',
      tradingPair: 'ETH/USDT',
      initialCapital: 3000.0,
      currentBalance: 3150.0,
      profitLoss: 150.0,
      profitLossPercent: 5.0,
      riskLevel: 'low',
      totalTrades: 124,
      winRate: 71.0,
      maxDrawdown: 2.1,
    ),
    Bot(
      id: '3',
      name: 'SOL Momentum',
      description: 'Импульсная торговля',
      strategy: 'scalping',
      status: 'paused',
      exchange: 'okx',
      tradingPair: 'SOL/USDT',
      initialCapital: 5000.0,
      currentBalance: 4850.0,
      profitLoss: -150.0,
      profitLossPercent: -3.0,
      riskLevel: 'high',
      totalTrades: 92,
      winRate: 52.1,
      maxDrawdown: 6.8,
    ),
  ];

  void _showCreateDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const CreateBotDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;

    List<Bot> filtered = _allBots.where((bot) {
      if (_activeTab == 'active') return bot.status == 'active';
      if (_activeTab == 'paused') return bot.status == 'paused';
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((bot) {
        final nameMatch = bot.name.toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final pairMatch = bot.tradingPair.toLowerCase()
            .contains(_searchQuery.toLowerCase());
        return nameMatch || pairMatch;
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Торговые боты',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.txt(context),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Управление автоматическими стратегиями',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.txtMuted(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  // ИСПРАВЛЕНО: Применяем наш глобальный UI-виджет кнопки
                  child: OstsButton(
                    label: 'Создать',
                    icon: Icons.add,
                    onTap: _showCreateDialog,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Торговые боты',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.txt(context),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Управление автоматическими стратегиями',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.txtMuted(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // ИСПРАВЛЕНО: Глобальный UI-виджет кнопки на десктопе
                OstsButton(
                  label: 'Создать',
                  icon: Icons.add,
                  onTap: _showCreateDialog,
                ),
              ],
            ),
          const SizedBox(height: 20),
          BotsFilters(
            activeTab: _activeTab,
            onTabChanged: (tab) => setState(() => _activeTab = tab),
            onSearchChanged: (q) => setState(() => _searchQuery = q),
          ),
          const SizedBox(height: 20),
          BotsListView(bots: filtered),
        ],
      ),
    );
  }
}
