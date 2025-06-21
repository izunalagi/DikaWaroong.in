import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildAnimated(Widget child) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: child),
    );
  }

  void _showAwesomeDialog({
    required DialogType dialogType,
    required String title,
    required String desc,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: onOk ?? () {},
      btnOkColor: Colors.orange.shade700,
    ).show();
  }

  Future<void> _verifyAccount() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || username.isEmpty) {
      _showAwesomeDialog(
        dialogType: DialogType.warning,
        title: "Peringatan",
        desc: "Email dan username tidak boleh kosong.",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Cek dulu apakah email dan username cocok dengan endpoint khusus atau langsung reset
      final response = await http.post(
        Uri.parse(
          "https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/forgot-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "username": username,
          "newPassword":
              "temp_password_123", // Password sementara untuk verifikasi
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _isVerified = true);
        _showAwesomeDialog(
          dialogType: DialogType.success,
          title: "Verifikasi Berhasil",
          desc: "Silakan masukkan password baru Anda.",
        );
      } else {
        final data = jsonDecode(response.body);
        _showAwesomeDialog(
          dialogType: DialogType.error,
          title: "Verifikasi Gagal",
          desc: data["message"] ?? "Email atau username tidak cocok.",
        );
      }
    } catch (e) {
      _showAwesomeDialog(
        dialogType: DialogType.error,
        title: "Error",
        desc: "Terjadi kesalahan saat verifikasi.\n$e",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showAwesomeDialog(
        dialogType: DialogType.warning,
        title: "Peringatan",
        desc: "Password baru dan konfirmasi password tidak boleh kosong.",
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showAwesomeDialog(
        dialogType: DialogType.warning,
        title: "Peringatan",
        desc: "Password baru dan konfirmasi password tidak sama.",
      );
      return;
    }

    if (newPassword.length < 6) {
      _showAwesomeDialog(
        dialogType: DialogType.warning,
        title: "Peringatan",
        desc: "Password minimal 6 karakter.",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
          "https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/forgot-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "username": username,
          "newPassword": newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showAwesomeDialog(
          dialogType: DialogType.success,
          title: "Reset Berhasil",
          desc:
              "Password berhasil direset. Silakan login dengan password baru.",
          onOk: () => Navigator.pop(context),
        );
      } else {
        _showAwesomeDialog(
          dialogType: DialogType.error,
          title: "Reset Gagal",
          desc: data["message"] ?? "Gagal mereset password.",
        );
      }
    } catch (e) {
      _showAwesomeDialog(
        dialogType: DialogType.error,
        title: "Error",
        desc: "Terjadi kesalahan saat reset password.\n$e",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAnimated(
                  Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimated(
                  Text(
                    _isVerified ? "Buat Password Baru" : "Verifikasi Akun",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAnimated(
                  Text(
                    _isVerified
                        ? "Masukkan password baru untuk akun Anda"
                        : "Masukkan email dan username untuk verifikasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 30),

                if (!_isVerified) ...[
                  _buildAnimated(
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.orange.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnimated(
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.orange.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAnimated(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isLoading ? null : _verifyAccount,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Verifikasi",
                                style: TextStyle(fontSize: 18),
                              ),
                    ),
                  ),
                ] else ...[
                  _buildAnimated(
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password Baru",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.orange.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnimated(
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.orange.shade700,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAnimated(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isLoading ? null : _resetPassword,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Reset Password",
                                style: TextStyle(fontSize: 18),
                              ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                _buildAnimated(
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Kembali ke Login",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
