import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CreateBotDialog extends StatefulWidget {
  const CreateBotDialog({super.key});

  @override
  State<CreateBotDialog> createState() =>
      _CreateBotDialogState();
}

class _CreateBotDialogState extends State<CreateBotDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _exchange = 'binance';
  String _pair = 'BTC/USDT';
  double _capital = 1000.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppTheme.surface(context),
      // ИСПРАВЛЕНО: Канонический класс скругления диалога
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width < 500 ? width * 0.9 : 460,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildLabel(context, 'Имя робота'),
                  _buildNameInput(),
                  const SizedBox(height: 12),
                  _buildLabel(context, 'Биржа'),
                  _buildExchangeDropdown(),
                  const SizedBox(height: 12),
                  _buildLabel(context, 'Торговая пара'),
                  _buildPairInput(),
                  const SizedBox(height: 12),
                  _buildLabel(
                    context,
                    'Стартовый капитал (\$${_capital.toStringAsFixed(0)})',
                  ),
                  _buildCapitalSlider(),
                  const SizedBox(height: 20),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Создание робота',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.txt(context),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.txtMuted(context),
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
      decoration: _inputDecoration('Например, BTC Scalper'),
      validator: (v) => v == null || v.isEmpty ? 'Введите имя' : null,
      onChanged: (v) => _name = v,
    );
  }

  Widget _buildExchangeDropdown() {
    return DropdownButtonFormField<String>(
      value: _exchange,
      dropdownColor: AppTheme.surface(context),
      style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
      decoration: _inputDecoration(''),
      items: ['binance', 'bybit', 'okx']
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e.toUpperCase()),
      ))
          .toList(),
      onChanged: (v) => setState(() => _exchange = v ?? 'binance'),
    );
  }

  Widget _buildPairInput() {
    return TextFormField(
      initialValue: _pair,
      style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
      decoration: _inputDecoration('BTC/USDT'),
      onChanged: (v) => _pair = v,
    );
  }

  Widget _buildCapitalSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppTheme.brand(context),
        thumbColor: AppTheme.brand(context),
      ),
      child: Slider(
        value: _capital,
        min: 100,
        max: 50000,
        divisions: 100,
        onChanged: (v) => setState(() => _capital = v),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Отмена',
            style: TextStyle(color: AppTheme.txtMuted(context)),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppTheme.brand(context),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Робот $_name создан')),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                'Запустить',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppTheme.txtMuted(context),
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppTheme.isDark(context)
          ? const Color(0xFF1E293B).withOpacity(0.3)
          : Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.bd(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.brand(context)),
      ),
    );
  }
}
