import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateKategoriPage extends StatefulWidget {
  const CreateKategoriPage({super.key});

  @override
  State<CreateKategoriPage> createState() => _CreateKategoriPageState();
}

class _CreateKategoriPageState extends State<CreateKategoriPage> {
  final TextEditingController _namaKategoriController = TextEditingController();
  final _apiBaseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net';

  Future<void> _simpanKategori() async {
    if (_namaKategoriController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama kategori wajib diisi")),
      );
      return;
    }

    final uri = Uri.parse('$_apiBaseUrl/api/Kategori');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'namaKategori': _namaKategoriController.text}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori berhasil ditambahkan")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${response.statusCode}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Tambah Kategori"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaKategoriController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Simpan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _simpanKategori,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
