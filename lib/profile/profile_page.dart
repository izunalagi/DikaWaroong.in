import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project/widgets/custom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = const FlutterSecureStorage();
  String userName = 'Loading...';
  String email = 'Loading...';
  bool isLoading = true;

  // Variabel untuk statistik dinamis
  int transaksiHariIni = 0;
  int transaksiDiproses = 0;
  int totalTransaksi = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadStatistik();
  }

  Future<void> _loadProfile() async {
    try {
      final token = await _storage.read(key: 'jwt');
      if (token == null) {
        setState(() {
          userName = 'Not logged in';
          email = 'No token found';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/me',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['username'] ?? 'No Name';
          email = data['email'] ?? 'No Email';
          isLoading = false;
        });
      } else {
        setState(() {
          userName = 'Unknown';
          email = 'Failed to load';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Error';
        email = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadStatistik() async {
    try {
      final token = await _storage.read(key: 'jwt');
      if (token == null) return;

      // Ambil info user
      final meRes = await http.get(
        Uri.parse(
          'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/me',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (meRes.statusCode != 200) return;

      final Map<String, dynamic> meData = jsonDecode(meRes.body);
      final akunId = meData['id_Akun'] ?? meData['id_akun'] ?? meData['id'];
      if (akunId == null) return;

      // Ambil semua transaksi
      final transaksiRes = await http.get(
        Uri.parse(
          'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Transaksi',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (transaksiRes.statusCode != 200) return;

      final List transaksiData = jsonDecode(transaksiRes.body);

      int hariIni = 0;
      int diproses = 0;
      int total = 0;

      final DateTime today = DateTime.now();
      final DateTime startOfDay = DateTime(today.year, today.month, today.day);
      final DateTime endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
      );

      print('🔍 Debug tanggal hari ini:');
      print('Today: $today');
      print('Start of day: $startOfDay');
      print('End of day: $endOfDay');

      for (var trx in transaksiData) {
        // Filter transaksi milik user ini
        final trxAkunId =
            trx['akunIdAkun'] ?? trx['akun_id_akun'] ?? trx['akunId'];
        if (trxAkunId == null || trxAkunId.toString() != akunId.toString()) {
          continue;
        }

        total++;

        // Cek status
        final status = trx['statusPesanan'] ?? trx['status_pesanan'];
        if (status == false) {
          diproses++;
        }

        // Cek tanggal hari ini - dengan debug yang lebih detail
        final tanggalStr = trx['tanggal'] ?? trx['tanggalTransaksi'];
        print('🔍 Tanggal string dari transaksi: $tanggalStr');

        final tanggal = DateTime.tryParse(tanggalStr ?? '');
        print('🔍 Tanggal parsed: $tanggal');

        if (tanggal != null) {
          final tanggalSaja = DateTime(
            tanggal.year,
            tanggal.month,
            tanggal.day,
          );
          final hariIniSaja = DateTime(today.year, today.month, today.day);

          print('🔍 Tanggal transaksi (date only): $tanggalSaja');
          print('🔍 Hari ini (date only): $hariIniSaja');
          print('🔍 Apakah sama? ${tanggalSaja.isAtSameMomentAs(hariIniSaja)}');

          if (tanggalSaja.isAtSameMomentAs(hariIniSaja)) {
            hariIni++;
            print('✅ Transaksi hari ini ditemukan! Total: $hariIni');
          }
        }
      }

      setState(() {
        transaksiHariIni = hariIni;
        transaksiDiproses = diproses;
        totalTransaksi = total;
      });
    } catch (e) {
      print('Error loading statistik: $e');
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController usernameController = TextEditingController(
      text: userName,
    );
    final TextEditingController emailController = TextEditingController(
      text: email,
    );
    bool isLoading = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Edit Profile'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              // Validasi input
                              if (usernameController.text.isEmpty ||
                                  emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Username dan Email harus diisi',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Validasi email format
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(emailController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Format email tidak valid'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              try {
                                final token = await _storage.read(key: 'jwt');
                                if (token == null) {
                                  throw 'Token tidak ditemukan';
                                }

                                final response = await http.put(
                                  Uri.parse(
                                    'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/edit-profile',
                                  ),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'username': usernameController.text,
                                    'email': emailController.text,
                                  }),
                                );

                                if (response.statusCode == 200) {
                                  Navigator.pop(context); // Tutup dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profile berhasil diperbarui',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Reload profile data
                                  _loadProfile();
                                } else {
                                  final errorData = jsonDecode(response.body);
                                  throw errorData['message'] ??
                                      'Gagal memperbarui profile';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('Simpan'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isLoading = false;
    bool obscureOldPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Ubah Password'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Password Lama
                    TextField(
                      controller: oldPasswordController,
                      obscureText: obscureOldPassword,
                      decoration: InputDecoration(
                        labelText: 'Password Lama',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOldPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureOldPassword = !obscureOldPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Password Baru
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Konfirmasi Password Baru
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              // Validasi input
                              if (oldPasswordController.text.isEmpty ||
                                  newPasswordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua field harus diisi'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password baru dan konfirmasi tidak sama',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Ubah bagian validasi ini dalam fungsi _showChangePasswordDialog

                              if (newPasswordController.text.length < 3) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password baru minimal 3 karakter',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                final token = await _storage.read(key: 'jwt');
                                if (token == null) {
                                  throw 'Token tidak ditemukan';
                                }

                                final response = await http.post(
                                  Uri.parse(
                                    'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/change-password',
                                  ),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'oldPassword': oldPasswordController.text,
                                    'newPassword': newPasswordController.text,
                                  }),
                                );

                                if (response.statusCode == 200) {
                                  Navigator.pop(context); // Tutup dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password berhasil diubah'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  final errorData = jsonDecode(response.body);
                                  throw errorData['message'] ??
                                      'Gagal mengubah password';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('Ubah Password'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Keluar'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari akun ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context); // Tutup dialog

                  // Hapus token
                  await _storage.delete(key: 'jwt');

                  // Navigasi ke login
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildStats(),
                    const SizedBox(height: 30),
                    _buildMenuList(),
                  ],
                ),
              ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/activity');
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage('assets/images/ayano.jpg'),
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(email, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatBox(
            transaksiHariIni.toString(),
            "Hari Ini",
            color: Colors.orange,
          ),
          _buildStatBox(
            transaksiDiproses.toString(),
            "Diproses",
            color: Colors.amber,
          ),
          _buildStatBox(
            totalTransaksi.toString(),
            "Total",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _MenuItem(
            icon: Icons.edit,
            title: "Edit Profile",
            subtitle: "Ubah username dan email",
            onTap: () => _showEditProfileDialog(context),
          ),
          _MenuItem(
            icon: Icons.person,
            title: "Username",
            subtitle: "@$userName",
          ),
          _MenuItem(icon: Icons.email, title: "Email", subtitle: email),
          _MenuItem(
            icon: Icons.lock,
            title: "Ubah Password",
            subtitle: "Ganti sandi akun",
            onTap: () => _showChangePasswordDialog(context),
          ),
          _MenuItem(
            icon: Icons.logout,
            title: "Keluar",
            subtitle: "Logout dari akun",
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String number, String label, {required Color color}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: 95,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade50,
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
