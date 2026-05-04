import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _isLoading = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeOut,
    );
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _register() async {
    if (emailCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & Password cannot be empty")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final hashed = AuthService.hashPassword(passCtrl.text);

    await StorageService.saveUser(
      email: emailCtrl.text.trim(),
      passwordHash: hashed,
      name: nameCtrl.text.trim(), 
    );

    setState(() => _isLoading = false);

    // popup biometrik
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Aktifkan Biometrik?"),
        content: const Text(
            "Gunakan fingerprint / face unlock untuk login lebih cepat."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Lain kali"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Aktifkan"),
          ),
        ],
      ),
    );

    await StorageService.setBiometricEnabled(result == true);

    if (!mounted) return;

    Navigator.pop(context); // balik ke login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // ── Logo & Title ──
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.accentLight
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text('💄', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'ChromaMe',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── Form Card ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign up ✨',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Start your journey with us',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Username
                      TextField(
                        controller: nameCtrl,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          prefixIcon:
                              Icon(Icons.person_2_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Email
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                              Icon(Icons.mail_outline_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextField(
                        controller: passCtrl,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock_outline_rounded, size: 18),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePass = !_obscurePass),
                            child: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Register button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Back to login
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}