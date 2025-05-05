import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProdukPage extends StatefulWidget {
  final Map<String, dynamic> produk;

  const EditProdukPage({super.key, required this.produk});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  String? _selectedKategori;
  File? _selectedImage;

  final List<String> _kategoriList = ['Makanan', 'Minuman'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.produk['nama']);
    _hargaController = TextEditingController(text: widget.produk['detail']);
    _stokController = TextEditingController(text: widget.produk['stok'].toString());
    _selectedKategori = widget.produk['kategori'] ?? _kategoriList.first;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _simpanPerubahan() {
    final updatedProduk = {
      'nama': _namaController.text,
      'detail': _hargaController.text,
      'stok': int.tryParse(_stokController.text) ?? 0,
      'kategori': _selectedKategori,
      'gambar': _selectedImage?.path, // path gambar jika dipilih
    };
    Navigator.pop(context, updatedProduk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Edit Produk'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.orange.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Upload Gambar',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ),
              ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _namaController,
              label: 'Nama Produk',
              icon: Icons.shopping_bag,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _hargaController,
              label: 'Harga (contoh: 10000)',
              icon: null,
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
              value: _selectedKategori,
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
                onPressed: _simpanPerubahan,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Perubahan',
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
