import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../components/bot_card.dart';

class BotsListView extends StatelessWidget {
  final List<Bot> bots;

  const BotsListView({super.key, required this.bots});

  @override
  Widget build(BuildContext context) {
    if (bots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'Роботы не найдены',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availW = constraints.maxWidth;

        // 1. Мобилки: Карточки вертикальной стопкой
        if (availW < 650) {
          return Column(
            children: bots.map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BotCard(bot: b),
              );
            }).toList(),
          );
        }

        // 2. Планшеты и десктоп: Бьем массив на порции по 2 или 3 карточки в ряд
        final int columns = availW < 1050 ? 2 : 3;
        final List<List<Bot>> rows = [];

        for (int i = 0; i < bots.length; i += columns) {
          final int end = (i + columns < bots.length) ? i + columns : bots.length;
          rows.add(bots.sublist(i, end));
        }

        return Column(
          children: rows.map((rowBots) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ...rowBots.map((b) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: BotCard(bot: b),
                    ),
                  )),
                  // Добиваем пустые места в строке флекс-пустышками
                  ...List.generate(columns - rowBots.length, (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: SizedBox.shrink(),
                    ),
                  )),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
