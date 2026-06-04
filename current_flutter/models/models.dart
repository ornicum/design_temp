import 'package:flutter/material.dart';

// Правильное расширение для красивого вывода валют
extension NumFormat on num {
  String toLocale() {
    final str = toStringAsFixed(0);
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAll(reg, ' ');
  }
}

// Модель торгового бота из Bot.json
class Bot {
  final String id;
  final String name;
  final String description;
  final String strategy;
  final String status;
  final String exchange;
  final String tradingPair;
  final double initialCapital;
  final double currentBalance;
  final double profitLoss;
  final double profitLossPercent;
  final String riskLevel;
  final int totalTrades;
  final double winRate;
  final double maxDrawdown;

  Bot({
    required this.id,
    required this.name,
    required this.description,
    required this.strategy,
    required this.status,
    required this.exchange,
    required this.tradingPair,
    required this.initialCapital,
    required this.currentBalance,
    required this.profitLoss,
    required this.profitLossPercent,
    required this.riskLevel,
    required this.totalTrades,
    required this.winRate,
    required this.maxDrawdown,
  });
}

// Модель сделки из Trade.json
class Trade {
  final String id;
  final String botId;
  final String botName;
  final String type; // buy или sell
  final String tradingPair;
  final double amount;
  final double price;
  final double total;
  final double profitLoss;
  final double fee;
  final String status;
  final DateTime executedAt;

  Trade({
    required this.id,
    required this.botId,
    required this.botName,
    required this.type,
    required this.tradingPair,
    required this.amount,
    required this.price,
    required this.total,
    required this.profitLoss,
    required this.fee,
    required this.status,
    required this.executedAt,
  });
}

// Модель лога из Notification.json
class AppNotification {
  final String id;
  final String botId;
  final String botName;
  final String type; // trade, error и т.д.
  final String title;
  final String message;
  final bool isRead;
  final String severity; // info, success, error

  AppNotification({
    required this.id,
    required this.botId,
    required this.botName,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.severity,
  });
}
