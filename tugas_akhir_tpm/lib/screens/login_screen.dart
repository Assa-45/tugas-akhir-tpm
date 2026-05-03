import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import '../services/storage_service.dart';
import '../services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  bool _showBiometric = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _initAuthState();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _initAuthState() async {
    final registered = await StorageService.isRegistered();
    final biometric = await StorageService.isBiometricEnabled();

    setState(() {
      _showBiometric = registered;
      _biometricEnabled = biometric;
    });
  }

  void _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _biometricLogin() async {
    if (!_biometricEnabled) {
      await StorageService.setBiometricEnabled(true);
      setState(() => _biometricEnabled = true);
      return;
    }

    final isAuthenticated = await BiometricService.authenticate();

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Autentikasi gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                            colors: [AppColors.primaryLight, AppColors.accentLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            )
                          ],
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
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Discover your personal color identity',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          letterSpacing: 0.2,
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome back 👋',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline_rounded, size: 18),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePass = !_obscurePass),
                            child: Icon(
                              _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Login button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Biometric button
                      if (_showBiometric)
                        const LabelDivider(label: 'or'),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _biometricLogin,
                          icon: const Icon(Icons.fingerprint_rounded, size: 20),
                          label: Text(
                            _biometricEnabled
                                ? 'Login Biometrik'
                                : 'Aktifkan Biometrik',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: const BorderSide(color: AppColors.accentLight, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Register
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      GestureDetector(
                        onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ).then((_) => _initAuthState());
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                // Security note
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.shield_outlined, size: 12, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Text(
                        'AES-256 encrypted · Secure session',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
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