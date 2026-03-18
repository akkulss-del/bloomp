import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/loading_button.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _codeController = TextEditingController();
  String? _codeError;
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    _sendCode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.verifyPhone(widget.phoneNumber);
    if (mounted) {
      setState(() => _codeSent = true);
    }
  }

  void _verify() {
    setState(() => _codeError = null);
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _codeError = 'Введите код из SMS');
      return;
    }
    _checkCode();
  }

  Future<void> _checkCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final verified = await authProvider.verifyCode(
      widget.phoneNumber,
      _codeController.text.trim(),
    );
    if (verified && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      setState(() => _codeError = 'Неверный код');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Подтверждение номера',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Введите код из SMS, отправленный на\n${widget.phoneNumber}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Код подтверждения',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
                decoration: InputDecoration(
                  hintText: '123456',
                  errorText: _codeError,
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.purple,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_codeSent)
                Center(
                  child: TextButton(
                    onPressed: authProvider.isLoading ? null : _sendCode,
                    child: Text(
                      'Отправить код повторно',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              LoadingButton(
                text: 'Подтвердить',
                onPressed: _verify,
                isLoading: authProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
