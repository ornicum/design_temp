import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../components/bot_card.dart';
import '../../init/i18n_manager.dart';

class BotsListView extends StatelessWidget {
  final List<Bot> bots;

  const BotsListView({super.key, required this.bots});

  @override
  Widget build(BuildContext context) {
    if (bots.isEmpty) {
      return const _EmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availW = constraints.maxWidth;

        // Если экран маленький — выводим простую вертикальную стопку
        if (availW < 650) {
          return _MobileView(bots: bots);
        }

        // Вычисляем количество колонок: 2 для планшетов, 3 для десктопа
        final int columns = availW < 1050 ? 2 : 3;
        return _DesktopGrid(bots: bots, columns: columns);
      },
    );
  }
}

// 1. ИЗОЛИРОВАННЫЙ ВИДЖЕТ: Заглушка пустого списка
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          I18n.t(context, 'bots_not_found'),
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
        ),
      ),
    );
  }
}

// 2. ИЗОЛИРОВАННЫЙ ВИДЖЕТ: Мобильное отображение (в один столбец)
class _MobileView extends StatelessWidget {
  final List<Bot> bots;
  const _MobileView({required this.bots});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bots.map((b) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BotCard(bot: b),
        );
      }).toList(),
    );
  }
}

// 3. ИЗОЛИРОВАННЫЙ ВИДЖЕТ: Адаптивная сетка строк и колонок для больших экранов
class _DesktopGrid extends StatelessWidget {
  final List<Bot> bots;
  final int columns;

  const _DesktopGrid({required this.bots, required this.columns});

  // Вспомогательный метод нарезки массива ботов на строки
  List<List<Bot>> _splitIntoRows() {
    final List<List<Bot>> rows = [];
    for (int i = 0; i < bots.length; i += columns) {
      final int end = (i + columns < bots.length) ? i + columns : bots.length;
      rows.add(bots.sublist(i, end));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _splitIntoRows();

    return Column(
      children: rows.map((rowBots) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Рендерим карточки ботов в текущей строке
              ...rowBots.map((b) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: BotCard(bot: b),
                ),
              )),
              // Добиваем пустые места в ряду невидимыми пустышками, если элементов меньше, чем колонок
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
  }
}
