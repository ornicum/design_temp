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
    },
    AppLanguage.en: {
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
    }
  };
}

class I18nNotifier extends ChangeNotifier {
  AppLanguage _currentLang = AppLanguage.ru;

  AppLanguage get currentLanguage => _currentLang;

  void setLanguage(AppLanguage lang) {
    if (_currentLang != lang) {
      _currentLang = lang;
      notifyListeners();
    }
  }
}

final i18nNotifier = I18nNotifier();
