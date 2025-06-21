import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> pelangganList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    const apiUrl =
        'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Auth/pelanggan';

    try {
      setState(() {
        isLoading = true;
      });

      // Ambil token dari SharedPreferences atau storage lain
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Jika menggunakan authorization, uncomment baris di bawah:
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          pelangganList = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        debugPrint('Gagal memuat data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error saat fetch data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade50,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Data Pelanggan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 20,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              )
              : pelangganList.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.orange.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Belum ada data pelanggan",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchPelanggan,
                color: Colors.deepOrange,
                child: ListView.builder(
                  itemCount: pelangganList.length,
                  itemBuilder: (context, index) {
                    final pelanggan = pelangganList[index];
                    return _buildPelangganCard(index, pelanggan);
                  },
                ),
              ),
    );
  }

  Widget _buildPelangganCard(int index, Map<String, dynamic> pelanggan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          radius: 24,
          child: Icon(Icons.person, color: Colors.deepOrange, size: 24),
        ),
        title: Text(
          pelanggan['username'] ?? 'Nama tidak tersedia',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pelanggan['email'] ?? 'Email tidak tersedia',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Pelanggan",
            style: TextStyle(
              fontSize: 10,
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
