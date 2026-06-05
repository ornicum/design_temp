import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../init/i18n_manager.dart';
import 'create_dialog/dialog_header.dart';
import 'create_dialog/dialog_inputs.dart';
import 'create_dialog/dialog_actions.dart';

class CreateBotDialog extends StatefulWidget {
  const CreateBotDialog({super.key});

  @override
  State<CreateBotDialog> createState() => _CreateBotDialogState();
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width < 500 ? width * 0.9 : 460),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DialogHeaderBlock(),
                  const SizedBox(height: 16),
                  DialogLabel(text: I18n.t(context, 'create_bot_modal_name_label')),
                  TextFormField(
                    style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
                    decoration: inputDecoration(context, I18n.t(context, 'create_bot_modal_name_hint')),
                    validator: (v) => v == null || v.isEmpty ? I18n.t(context, 'create_bot_modal_name_error') : null,
                    onChanged: (v) => _name = v,
                  ),
                  const SizedBox(height: 12),
                  DialogLabel(text: I18n.t(context, 'create_bot_modal_exchange_label')),
                  DropdownButtonFormField<String>(
                    value: _exchange,
                    dropdownColor: AppTheme.surface(context),
                    style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
                    decoration: inputDecoration(context, ''),
                    items: ['binance', 'bybit', 'okx'].map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _exchange = v ?? 'binance'),
                  ),
                  const SizedBox(height: 12),
                  DialogLabel(text: I18n.t(context, 'create_bot_modal_pair_label')),
                  TextFormField(
                    initialValue: _pair,
                    style: TextStyle(fontSize: 14, color: AppTheme.txt(context)),
                    decoration: inputDecoration(context, 'BTC/USDT'),
                    onChanged: (v) => _pair = v,
                  ),
                  const SizedBox(height: 12),
                  DialogLabel(text: '${I18n.t(context, 'create_bot_modal_capital_label')} (\$${_capital.toStringAsFixed(0)})'),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(activeTrackColor: AppTheme.brand(context), thumbColor: AppTheme.brand(context)),
                    child: Slider(value: _capital, min: 100, max: 50000, divisions: 100, onChanged: (v) => setState(() => _capital = v)),
                  ),
                  const SizedBox(height: 20),
                  DialogActionsBlock(formKey: _formKey, getName: () => _name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
