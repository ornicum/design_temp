import 'package:flutter/material.dart';
import '../app_theme.dart';

class CryptoExchangeAccount {
  final String id; final String name; final String exchange;
  final String maskedKey; final bool isHealthy;
  CryptoExchangeAccount({required this.id, required this.name,
    required this.exchange, required this.maskedKey, required this.isHealthy});
}

class ApiKeysScreen extends StatefulWidget {
  const ApiKeysScreen({super.key});
  @override State<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends State<ApiKeysScreen> {
  final List<CryptoExchangeAccount> _accounts = [
    CryptoExchangeAccount(id: '1', name: 'Основной Спот', exchange: 'Binance', maskedKey: 'Dx9a1...8f4b', isHealthy: true),
    CryptoExchangeAccount(id: '2', name: 'Фьючерсный Bybit', exchange: 'Bybit', maskedKey: 'Kl8c2...1a9e', isHealthy: true),
    CryptoExchangeAccount(id: '3', name: 'Инвестиционный OKX', exchange: 'OKX', maskedKey: 'Op4m7...3c2f', isHealthy: false),
  ];

  final _formKey = GlobalKey<FormState>(); String _selectedExchange = 'Binance';
  final _accountNameController = TextEditingController();
  final _apiKeyController = TextEditingController(); final _apiSecretController = TextEditingController();

  @override void dispose() {
    _accountNameController.dispose(); _apiKeyController.dispose();
    _apiSecretController.dispose(); super.dispose();
  }

  void _addNewKey() {
    final String rawKey = _apiKeyController.text;
    final String masked = rawKey.length > 8 ? '${rawKey.substring(0, 4)}...${rawKey.substring(rawKey.length - 4)}' : 'api_key_hidden';
    setState(() { _accounts.add(CryptoExchangeAccount(id: DateTime.now().millisecondsSinceEpoch.toString(), name: _accountNameController.text, exchange: _selectedExchange, maskedKey: masked, isHealthy: true)); });
    _accountNameController.clear(); _apiKeyController.clear(); _apiSecretController.clear();
  }

  @override Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width; final bool isMobile = width < 900;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (isMobile) ...[_buildAddKeyForm(), const SizedBox(height: 32), const Text('АКТИВНЫЕ КЛЮЧИ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 16), _buildConnectionsGrid(1)]
          else ...[Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 4, child: _buildAddKeyForm()), const SizedBox(width: 32), Expanded(flex: 6, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('АКТИВНЫЕ КЛЮЧИ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 16), _buildConnectionsGrid(2)]))])]
        ]),
      ),
    );
  }

  Widget _buildAddKeyForm() {
    return Container(
      padding: const EdgeInsets.all(24.0), decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.border)),
      child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ДОБАВИТЬ НОВЫЙ КЛЮЧ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 20),
          _HoverDropdown(onChanged: (val) => setState(() => _selectedExchange = val)), const SizedBox(height: 16),
          _HoverTextField(controller: _accountNameController, hintText: 'Название аккаунта'), const SizedBox(height: 16),
          _HoverTextField(controller: _apiKeyController, hintText: 'API Key', obscureText: true), const SizedBox(height: 16),
          _HoverTextField(controller: _apiSecretController, hintText: 'API Secret', obscureText: true), const SizedBox(height: 24),
          _FormSubmitButton(onPressed: () { if (_formKey.currentState!.validate()) _addNewKey(); }),
      ])),
    );
  }

  Widget _buildConnectionsGrid(int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _accounts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: crossAxisCount == 1 ? 2.5 : 1.8),
      itemBuilder: (context, index) { return _ApiKeyCard(account: _accounts[index], onDelete: () => setState(() => _accounts.removeWhere((e) => e.id == _accounts[index].id))); },
    );
  }
}

class _ApiKeyCard extends StatefulWidget {
  final CryptoExchangeAccount account; final VoidCallback onDelete;
  const _ApiKeyCard({required this.account, required this.onDelete});
  @override State<_ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends State<_ApiKeyCard> {
  bool _isHovered = false;
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), decoration: BoxDecoration(color: const Color(0xFF0E1424), borderRadius: BorderRadius.circular(8), border: Border.all(color: _isHovered ? AppTheme.primary : AppTheme.border)),
        child: InkWell(
          onTap: () {
            showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: const Color(0xFF0E1424), title: Text(widget.account.name, style: const TextStyle(color: Colors.white)), content: Text('Биржа: ${widget.account.exchange}\nКлюч: ${widget.account.maskedKey}', style: const TextStyle(color: Colors.grey)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.account.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)), Text(widget.account.exchange, style: const TextStyle(color: Colors.cyan, fontSize: 12))]),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFF64748B)), onPressed: widget.onDelete),
                ]),
                Text(widget.account.maskedKey, style: const TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFF64748B), fontSize: 12)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: widget.account.isHealthy ? AppTheme.success.withOpacity(0.1) : AppTheme.destructive.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(widget.account.isHealthy ? 'CONNECTED' : 'AUTH ERROR', style: TextStyle(color: widget.account.isHealthy ? AppTheme.success : AppTheme.destructive, fontSize: 10, fontWeight: FontWeight.bold))),
            ]),
          ),
        ),
      ),
    );
  }
}

class _HoverTextField extends StatefulWidget {
  final TextEditingController controller; final String hintText; final bool obscureText;
  const _HoverTextField({required this.controller, required this.hintText, this.obscureText = false});
  @override State<_HoverTextField> createState() => _HoverTextFieldState();
}

class _HoverTextFieldState extends State<_HoverTextField> {
  bool _isHovered = false; bool _isFocused = false; final FocusNode _focusNode = FocusNode();
  @override void initState() { super.initState(); _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus)); }
  @override void dispose() { _focusNode.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(duration: const Duration(milliseconds: 150), decoration: BoxDecoration(color: const Color(0xFF0A0F1D), borderRadius: BorderRadius.circular(6), border: Border.all(color: _isFocused ? AppTheme.primary : (_isHovered ? const Color(0xFF475569) : AppTheme.border))), child: TextFormField(controller: widget.controller, focusNode: _focusNode, obscureText: widget.obscureText, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: widget.hintText, hintStyle: const TextStyle(color: Color(0xFF475569)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), border: InputBorder.none))),
    );
  }
}

class _HoverDropdown extends StatefulWidget {
  final Function(String) onChanged; const _HoverDropdown({required this.onChanged});
  @override State<_HoverDropdown> createState() => _HoverDropdownState();
}

class _HoverDropdownState extends State<_HoverDropdown> {
  bool _isHovered = false; String _currentValue = 'Binance';
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(duration: const Duration(milliseconds: 150), padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: const Color(0xFF0A0F1D), borderRadius: BorderRadius.circular(6), border: Border.all(color: _isHovered ? const Color(0xFF475569) : AppTheme.border)), child: DropdownButtonFormField<String>(value: _currentValue, dropdownColor: const Color(0xFF0E1424), style: const TextStyle(color: Colors.white, fontSize: 14), decoration: const InputDecoration(border: InputBorder.none), items: ['Binance', 'Bybit', 'OKX'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) { if (val != null) { setState(() => _currentValue = val); widget.onChanged(val); } })),
    );
  }
}

class _FormSubmitButton extends StatefulWidget {
  final VoidCallback onPressed; const _FormSubmitButton({required this.onPressed});
  @override State<_FormSubmitButton> createState() => _FormSubmitButtonState();
}

class _FormSubmitButtonState extends State<_FormSubmitButton> {
  bool _isHovered = false;
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(duration: const Duration(milliseconds: 150), width: double.infinity, height: 46, decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: _isHovered ? [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 16)] : null), child: ElevatedButton(onPressed: widget.onPressed, style: ElevatedButton.styleFrom(backgroundColor: _isHovered ? AppTheme.primary : AppTheme.primary.withOpacity(0.85), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), elevation: 0), child: const Text('ПОДКЛЮЧИТЬ АККАУНТ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.background)))),
    );
  }
}
