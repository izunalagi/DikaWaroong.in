import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditKategoriPage extends StatefulWidget {
  final Map<String, dynamic> kategori;

  const EditKategoriPage({super.key, required this.kategori});

  @override
  State<EditKategoriPage> createState() => _EditKategoriPageState();
}

class _EditKategoriPageState extends State<EditKategoriPage> {
  final TextEditingController _namaKategoriController = TextEditingController();
  final _apiBaseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    _namaKategoriController.text = widget.kategori['namaKategori'] ?? '';
  }

  Future<void> _updateKategori() async {
    if (_namaKategoriController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama kategori wajib diisi")),
      );
      return;
    }

    final uri = Uri.parse(
      '$_apiBaseUrl/api/Kategori/${widget.kategori['idKategori']}',
    );
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'namaKategori': _namaKategoriController.text}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori berhasil diupdate")),
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
        title: const Text("Edit Kategori"),
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
                  "Simpan Perubahan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _updateKategori,
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
