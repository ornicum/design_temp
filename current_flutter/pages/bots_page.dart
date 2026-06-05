import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/pages/bots/bots_filters.dart';
import 'package:osts_mobile_app/pages/bots/bots_list_view.dart';
import 'package:osts_mobile_app/pages/bots/create_bot_dialog.dart';
import 'package:osts_mobile_app/components/ui/osts_button.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class BotsPage extends StatefulWidget {
  const BotsPage({super.key});

  @override
  State<BotsPage> createState() => _BotsPageState();
}

class _BotsPageState extends State<BotsPage> {
  String _activeTab = 'all';
  String _searchQuery = '';

  // ВОССТАНОВЛЕНО: Полный массив ботов со всеми терминальными статусами
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
    Bot(
      id: '4',
      name: 'XRP Reversal Pro',
      description: 'Контртрендовая стратегия',
      strategy: 'grid',
      status: 'stopped', // Восстановленный статус
      exchange: 'binance',
      tradingPair: 'XRP/USDT',
      initialCapital: 4000.0,
      currentBalance: 4000.0,
      profitLoss: 0.0,
      profitLossPercent: 0.0,
      riskLevel: 'medium',
      totalTrades: 310,
      winRate: 61.2,
      maxDrawdown: 3.9,
    ),
    Bot(
      id: '5',
      name: 'ADA Breakout Multi',
      description: 'Пробой уровней поддержки',
      strategy: 'breakout',
      status: 'stopped', // Восстановленный статус
      exchange: 'bybit',
      tradingPair: 'ADA/USDT',
      initialCapital: 2500.0,
      currentBalance: 2100.0,
      profitLoss: -400.0,
      profitLossPercent: -16.0,
      riskLevel: 'high',
      totalTrades: 45,
      winRate: 40.0,
      maxDrawdown: 18.2,
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

    // ВОССТАНОВЛЕНО: Строгая фильтрация по всем 4 вкладкам, включая stopped
    List<Bot> filtered = _allBots.where((bot) {
      if (_activeTab == 'active') return bot.status == 'active';
      if (_activeTab == 'paused') return bot.status == 'paused';
      if (_activeTab == 'stopped') return bot.status == 'stopped';
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((bot) {
        final nameMatch = bot.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final pairMatch = bot.tradingPair.toLowerCase().contains(_searchQuery.toLowerCase());
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
                  I18n.t(context, 'bots_title'),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.txt(context), letterSpacing: -0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  I18n.t(context, 'bots_subtitle'),
                  style: TextStyle(fontSize: 13, color: AppTheme.txtMuted(context)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OstsButton(
                    label: I18n.t(context, 'bots_btn_create'),
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
                        I18n.t(context, 'bots_title'),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.txt(context), letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        I18n.t(context, 'bots_subtitle'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: AppTheme.txtMuted(context)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OstsButton(
                  label: I18n.t(context, 'bots_btn_create'),
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
