import 'package:flutter/material.dart';

enum AppLanguage { ru, en }

class I18n extends InheritedNotifier<I18nNotifier> {
  const I18n({
    super.key,
    required super.notifier,
    required super.child,
  });

  static I18nNotifier of(BuildContext context) {
    final I18n? inherited = context.dependOnInheritedWidgetOfExactType<I18n>();
    assert(inherited != null, 'No I18n found in context');
    return inherited!.notifier!;
  }

  static String t(BuildContext context, String key) {
    final lang = of(context).currentLanguage;
    return _localizedValues[lang]?[key] ?? key;
  }

  static const Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.ru: {
      // Экран Системных Логов / Уведомлений
      'notifications_screen_title': 'Системные логи',
      'notifications_screen_dialog_title': 'Детали системного события',
      'notifications_screen_source': 'Источник',
      'notifications_screen_dialog_close': 'Закрыть',

      // Шаблоны уведомлений (Динамические плейсхолдеры)
      'notif_msg_trade_buy': 'Исполнен лимитный ордер BUY #{id} на объем {amount} {pair} @ \${price}', // Экранирован знак доллара
      'notif_msg_error_api': 'API Error: {error}. Запрос отклонен биржей.',
      'notif_msg_warning_volatility': 'Внимание: Высокая волатильность на рынке. Сетка ордеров расширена на {percent}%.',
      'notif_msg_info_service': 'Микросервис {service} успешно перезапущен. Синхронизация БД завершена.',

      // Сайдбар и Навигация
      'nav_overview': 'Обзор',
      'nav_bots': 'Боты',
      'nav_analytics': 'Аналитика',
      'nav_api_keys': 'API Ключи',
      'nav_settings': 'Настройки',
      'nav_logout': 'Выход',
      'nav_collapse': 'Свернуть',
      'nav_expand': 'Развернуть',

      // Дашборд
      'dash_welcome': 'Добро пожаловать',
      'dash_overview': 'Обзор вашего торгового портфеля',
      'dash_total_balance': 'Общий баланс',
      'dash_active_bots': 'Активные боты',
      'dash_total_pnl': 'Общий PnL',
      'dash_total_trades': 'Всего сделок',
      'dash_chart_title': 'Динамика портфеля',
      'dash_chart_sub': 'Последние 30 дней',
      'dash_active_section': 'Активные боты',
      'dash_all_bots_link': 'Все боты →',

      // Страница ботов
      'bots_title': 'Торговые боты',
      'bots_subtitle': 'Управление автоматическими стратегиями',
      'bots_btn_create': 'Создать',
      'bots_search_hint': 'Поиск по имени или паре...',
      'bots_filter_all': 'Все',
      'bots_filter_active': 'Активные',
      'bots_filter_paused': 'На паузе',
      'bots_filter_stopped': 'Остановлены',
      'bots_not_found': 'Роботы не найдены',
      'bots_empty_title': 'Создайте первого бота',
      'bots_empty_desc': 'Настройте торговую стратегию и запустите автоматическую торговлю',

      // Модальное окно создания бота (Строгие префиксы)
      'create_bot_modal_title': 'Создание робота',
      'create_bot_modal_name_label': 'Имя робота',
      'create_bot_modal_name_hint': 'Например, BTC Scalper',
      'create_bot_modal_name_error': 'Введите имя',
      'create_bot_modal_exchange_label': 'Биржа',
      'create_bot_modal_pair_label': 'Торговая пара',
      'create_bot_modal_capital_label': 'Стартовый капитал',
      'create_bot_modal_cancel': 'Отмена',
      'create_bot_modal_launch': 'Запустить',
      'create_bot_modal_success_toast': 'Робот {name} создан',

      // Общие компоненты
      'trades_table_title': 'Последние сделки',
      'trades_table_empty': 'Пока нет сделок',
      'trades_table_empty_sub': 'Запустите бота, чтобы увидеть торговую активность',
      'trades_table_th_pair': 'Пара',
      'trades_table_th_type': 'Тип',
      'trades_table_th_price': 'Цена',
      'trades_table_th_volume': 'Объём',
      'trades_table_th_pnl': 'PnL',
      'trades_table_th_time': 'Время',
      'trades_type_buy': 'Покупка',
      'trades_type_sell': 'Продажа',
      'trades_toast_details': 'Детали сделки {id} скоро будут доступны',
      'lang_ru': 'Русский',
      'lang_en': 'English',

      // Для секции AppLanguage.ru:
      'analytics_screen_title': 'Аналитика',
      'analytics_screen_subtitle': 'Детальный анализ портфеля и торговой активности',
      'analytics_total_balance': 'Общий баланс',
      'analytics_total_pnl': 'Общий PnL',
      'analytics_total_trades': 'Всего сделок',
      'analytics_avg_winrate': 'Средний Win Rate',
      'analytics_trading_volume': 'Объём торгов',
      'analytics_active_bots': 'Активных ботов',
      'analytics_invested_label': 'Вложено: {value}',
      'analytics_profitable_label': 'Прибыльных: {value}',
      'analytics_stable_label': 'Стабильно',
      'analytics_trades_count_label': '{value} сделки',
      'analytics_total_label': 'Всего: {value}',
      'analytics_bots_profitability': 'Прибыльность ботов',
      'analytics_bots_pnl_desc': 'PnL каждого бота в долларах',
      'analytics_daily_pnl': 'Ежедневный PnL',
      'analytics_balance_dist': 'Распределение баланса',
      'analytics_by_exchanges': 'По биржам',
      'analytics_by_strategies': 'По стратегиям',
      'analytics_table_title': 'Сравнение ботов',
      'analytics_th_bot': 'Бот',
      'analytics_th_balance': 'Баланс',
      'analytics_th_pnl': 'PnL',
      'analytics_th_pnl_pct': 'PnL %',
      'analytics_th_winrate': 'Win Rate',
      'analytics_th_drawdown': 'Просадка',
      'analytics_th_trades': 'Сделки',
    },
    AppLanguage.en: {
      // System Logs / Notifications Screen
      'notifications_screen_title': 'System Logs',
      'notifications_screen_dialog_title': 'System Event Details',
      'notifications_screen_source': 'Source',
      'notifications_screen_dialog_close': 'Close',

      // Notification Templates (Dynamic placeholders)
      // Notification Templates (Dynamic placeholders)
      'notif_msg_trade_buy': 'Limit order BUY #{id} executed for {amount} {pair} @ \${price}', // Экранирован знак доллара
      'notif_msg_error_api': 'API Error: {error}. Request rejected by exchange.',
      'notif_msg_warning_volatility': 'Warning: High market volatility. Grid expanded by {percent}%.',
      'notif_msg_info_service': 'Microservice {service} successfully restarted. DB sync completed.',

      // Sidebar & Navigation
      'nav_overview': 'Overview',
      'nav_bots': 'Bots',
      'nav_analytics': 'Analytics',
      'nav_api_keys': 'API Keys',
      'nav_settings': 'Settings',
      'nav_logout': 'Logout',
      'nav_collapse': 'Collapse',
      'nav_expand': 'Expand',

      // Dashboard
      'dash_welcome': 'Welcome',
      'dash_overview': 'Overview of your trading portfolio',
      'dash_total_balance': 'Total Balance',
      'dash_active_bots': 'Active Bots',
      'dash_total_pnl': 'Total PnL',
      'dash_total_trades': 'Total Trades',
      'dash_chart_title': 'Portfolio Performance',
      'dash_chart_sub': 'Last 30 days',
      'dash_active_section': 'Active Bots',
      'dash_all_bots_link': 'All bots →',

      // Bots Page
      'bots_title': 'Trading Bots',
      'bots_subtitle': 'Manage automated trading strategies',
      'bots_btn_create': 'Create',
      'bots_search_hint': 'Search by name or pair...',
      'bots_filter_all': 'All',
      'bots_filter_active': 'Active',
      'bots_filter_paused': 'Paused',
      'bots_filter_stopped': 'Stopped',
      'bots_not_found': 'Robots not found',
      'bots_empty_title': 'Create your first bot',
      'bots_empty_desc': 'Configure a trading strategy and launch automated trading',

      // Create Bot Modal (Strict prefixes)
      'create_bot_modal_title': 'Create Robot',
      'create_bot_modal_name_label': 'Robot Name',
      'create_bot_modal_name_hint': 'e.g., BTC Scalper',
      'create_bot_modal_name_error': 'Please enter a name',
      'create_bot_modal_exchange_label': 'Exchange',
      'create_bot_modal_pair_label': 'Trading Pair',
      'create_bot_modal_capital_label': 'Starting Capital',
      'create_bot_modal_cancel': 'Cancel',
      'create_bot_modal_launch': 'Launch',
      'create_bot_modal_success_toast': 'Bot {name} created',

      // Common Components
      'trades_table_title': 'Recent Trades',
      'trades_table_empty': 'No trades yet',
      'trades_table_empty_sub': 'Launch a bot to see trading activity',
      'trades_table_th_pair': 'Pair',
      'trades_table_th_type': 'Type',
      'trades_table_th_price': 'Price',
      'trades_table_th_volume': 'Volume',
      'trades_table_th_pnl': 'PnL',
      'trades_table_th_time': 'Time',
      'trades_type_buy': 'Buy',
      'trades_type_sell': 'Sell',
      'trades_toast_details': 'Trade details for {id} will be available soon',
      'lang_ru': 'Russian',
      'lang_en': 'English',

      // Для секции AppLanguage.en:
      'analytics_screen_title': 'Analytics',
      'analytics_screen_subtitle': 'Detailed analysis of portfolio and trading activity',
      'analytics_total_balance': 'Total Balance',
      'analytics_total_pnl': 'Total PnL',
      'analytics_total_trades': 'Total Trades',
      'analytics_avg_winrate': 'Average Win Rate',
      'analytics_trading_volume': 'Trading Volume',
      'analytics_active_bots': 'Active Bots',
      'analytics_invested_label': 'Invested: {value}',
      'analytics_profitable_label': 'Profitable: {value}',
      'analytics_stable_label': 'Stable',
      'analytics_trades_count_label': '{value} trades',
      'analytics_total_label': 'Total: {value}',
      'analytics_bots_profitability': 'Bots Profitability',
      'analytics_bots_pnl_desc': 'PnL of each bot in dollars',
      'analytics_daily_pnl': 'Daily PnL',
      'analytics_balance_dist': 'Balance Distribution',
      'analytics_by_exchanges': 'By Exchanges',
      'analytics_by_strategies': 'By Strategies',
      'analytics_table_title': 'Bots Comparison',
      'analytics_th_bot': 'Bot',
      'analytics_th_balance': 'Balance',
      'analytics_th_pnl': 'PnL',
      'analytics_th_pnl_pct': 'PnL %',
      'analytics_th_winrate': 'Win Rate',
      'analytics_th_drawdown': 'Drawdown',
      'analytics_th_trades': 'Trades',
    }
  };
}

class I18nNotifier extends ChangeNotifier {
  AppLanguage _currentLang = AppLanguage.en;

  AppLanguage get currentLanguage => _currentLang;

  void setLanguage(AppLanguage lang) {
    if (_currentLang != lang) {
      _currentLang = lang;
      notifyListeners();
    }
  }
}

final i18nNotifier = I18nNotifier();
