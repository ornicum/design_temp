import 'package:flutter/material.dart';
import '../../app_theme.dart';

class BotsFilters extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onSearchChanged;

  const BotsFilters({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 650;

    final List<Map<String, String>> tabs = [
      {'id': 'all', 'label': 'Все'},
      {'id': 'active', 'label': 'Активные'},
      {'id': 'paused', 'label': 'Пауза'},
    ];

    final Widget searchField = Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.isDark(context)
            ? const Color(0xFF1E293B).withOpacity(0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.bd(context)),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: 13, color: AppTheme.txt(context)),
        decoration: InputDecoration(
          hintText: 'Поиск робота...',
          hintStyle: TextStyle(color: AppTheme.txtMuted(context), fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 16, color: AppTheme.txtMuted(context)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );

    final Widget tabSelector = Row(
      mainAxisSize: MainAxisSize.min,
      children: tabs.map((t) {
        final bool isSel = activeTab == t['id'];
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 32,
            child: Material(
              color: isSel
                  ? AppTheme.brand(context).withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => onTabChanged(t['id']!),
                splashColor: AppTheme.brand(context).withOpacity(0.15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      t['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        color: isSel ? AppTheme.brand(context) : AppTheme.txtMuted(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchField,
          const SizedBox(height: 12),
          tabSelector,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tabSelector,
        SizedBox(width: 220, child: searchField),
      ],
    );
  }
}
