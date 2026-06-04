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

    final double width = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (width >= 1050) {
      crossAxisCount = 3;
    } else if (width >= 650) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 240, // ИСПРАВЛЕНО: увеличен размер для предотвращения bottom overflow
      ),
      itemBuilder: (context, index) {
        return BotCard(bot: bots[index]);
      },
    );
  }
}
