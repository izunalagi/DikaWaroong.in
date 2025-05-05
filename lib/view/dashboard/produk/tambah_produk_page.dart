import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahProdukPage extends StatefulWidget {
  const TambahProdukPage({super.key});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  String? _selectedKategori;
  final List<String> _kategoriList = ['Makanan', 'Minuman'];
  File? _gambar;

  Future<void> _pickGambar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _gambar = File(picked.path);
      });
    }
  }

  void _simpanProduk() {
    if (_namaController.text.isEmpty || _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan harga wajib diisi")),
      );
      return;
    }

    final produkBaru = {
      'nama': _namaController.text,
      'detail': _hargaController.text,
      'stok': int.tryParse(_stokController.text) ?? 0,
      'kategori': _selectedKategori ?? _kategoriList.first,
      'gambar': _gambar,
    };

    Navigator.pop(context, produkBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickGambar,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _gambar == null
                    ? const Center(child: Text("Upload Gambar"))
                    : Image.file(_gambar!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _namaController,
              label: 'Nama Produk',
              icon: Icons.shopping_bag,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _hargaController,
              label: 'Harga (contoh: 10000)',
              prefixText: 'Rp ',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _stokController,
              label: 'Stok',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedKategori ?? _kategoriList.first,
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Kategori',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedKategori = value;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _simpanProduk,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Tambah Produk',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixText: prefixText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
