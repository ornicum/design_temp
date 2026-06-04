import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_theme.dart';
import '../app_router.dart'; // Импорт строго на своем месте вверху файла

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF0E1424),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppTheme.success),
          ),
          content: const Row(
            children: [
              Icon(Icons.lock_open_outlined, color: AppTheme.success, size: 20),
              SizedBox(width: 12),
              Text(
                'Авторизация успешна. Вход в систему...',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );

      // АКТИВАЦИЯ СТРАТЕГИЧЕСКОГО МАРКЕРА:
      isUserAuthenticated = true;

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) context.go('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080D1A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1424),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFF14243B), shape: BoxShape.circle),
                      child: const Icon(Icons.bolt, color: AppTheme.primary, size: 32),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text('Вход в Bot Platform', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('Введите данные для доступа к терминалу', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ),
                  const SizedBox(height: 32),

                  _buildInputLabel('ЭЛЕКТРОННАЯ ПОЧТА'),
                  _HoverLoginTextField(
                    controller: _emailController,
                    hintText: 'name@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => (val == null || !val.contains('@')) ? 'Введите корректный Email' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildInputLabel('ПАРОЛЬ'),
                  _buildPasswordInput(),
                  const SizedBox(height: 32),

                  _LoginSubmitButton(onPressed: _handleLogin),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget _buildPasswordInput() {
    return _HoverLoginTextField(
      controller: _passwordController,
      hintText: '••••••••',
      obscureText: _obscurePassword,
      validator: (val) => (val == null || val.length < 6) ? 'Пароль должен быть от 6 символов' : null,
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF475569), size: 18),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }
}

class _HoverLoginTextField extends StatefulWidget {
  final TextEditingController controller; final String hintText; final bool obscureText; final TextInputType? keyboardType; final Widget? suffixIcon; final String? Function(String?)? validator;
  const _HoverLoginTextField({required this.controller, required this.hintText, this.obscureText = false, this.keyboardType, this.suffixIcon, this.validator});
  @override State<_HoverLoginTextField> createState() => _HoverLoginTextFieldState();
}

class _HoverLoginTextFieldState extends State<_HoverLoginTextField> {
  bool _isHovered = false; final FocusNode _focusNode = FocusNode(); bool _isFocused = false;
  @override void initState() { super.initState(); _focusNode.addListener(() { setState(() => _isFocused = _focusNode.hasFocus); }); }
  @override void dispose() { _focusNode.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), curve: Curves.easeInOut,
        decoration: BoxDecoration(color: const Color(0xFF0A0F1D), borderRadius: BorderRadius.circular(6), border: Border.all(color: _isFocused ? AppTheme.primary : (_isHovered ? const Color(0xFF475569) : AppTheme.border), width: _isFocused ? 1.5 : 1.0)),
        child: TextFormField(controller: widget.controller, focusNode: _focusNode, obscureText: widget.obscureText, keyboardType: widget.keyboardType, validator: widget.validator, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: widget.hintText, hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), suffixIcon: widget.suffixIcon, border: InputBorder.none, errorStyle: const TextStyle(height: 0, fontSize: 0))),
      ),
    );
  }
}

class _LoginSubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _LoginSubmitButton({required this.onPressed});
  @override State<_LoginSubmitButton> createState() => _LoginSubmitButtonState();
}

class _LoginSubmitButtonState extends State<_LoginSubmitButton> {
  bool _isHovered = false;
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), width: double.infinity, height: 46,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: _isHovered ? [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 16, spreadRadius: 1)] : null),
        child: ElevatedButton(onPressed: widget.onPressed, style: ElevatedButton.styleFrom(backgroundColor: _isHovered ? AppTheme.primary : AppTheme.primary.withOpacity(0.85), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), elevation: 0), child: const Text('ВОЙТИ В ТЕРМИНАЛ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.background, letterSpacing: 0.5))),
      ),
    );
  }
}
