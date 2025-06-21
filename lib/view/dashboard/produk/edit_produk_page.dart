import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class EditProdukPage extends StatefulWidget {
  final Map<String, dynamic> produk;

  const EditProdukPage({super.key, required this.produk});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String? _selectedKategori;
  List<Map<String, dynamic>> _kategoriList = [];

  File? _gambarFile;
  Uint8List? _gambarBytesWeb;
  String? _namaFileWeb;
  String? _urlGambarLama;

  final _apiBaseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    _isiDataProduk();
    fetchKategori();
  }

  void _isiDataProduk() {
    _namaController.text = widget.produk['namaProduk'] ?? '';
    _hargaController.text = widget.produk['harga'].toString();
    _stokController.text = widget.produk['stock'].toString();
    _keteranganController.text = widget.produk['keterangan'] ?? '';
    _selectedKategori = widget.produk['kategori']?['namaKategori'];
    _urlGambarLama = widget.produk['gambar'];
  }

  Future<void> fetchKategori() async {
    final apiUrl = '$_apiBaseUrl/api/Kategori';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _kategoriList = List<Map<String, dynamic>>.from(data);
          _selectedKategori ??=
              _kategoriList.isNotEmpty
                  ? _kategoriList.first['namaKategori']
                  : null;
        });
      } else {
        debugPrint('Gagal load kategori: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error load kategori: $e');
    }
  }

  Future<void> _pickGambar() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _gambarBytesWeb = result.files.single.bytes;
          _namaFileWeb = result.files.single.name;
        });
      }
    } else {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _gambarFile = File(picked.path);
        });
      }
    }
  }

  Future<void> _simpanProduk() async {
    if (_namaController.text.isEmpty || _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan harga wajib diisi")),
      );
      return;
    }

    final kategoriId = await _getIdKategoriFromNama(_selectedKategori!);
    final uri = Uri.parse(
      '$_apiBaseUrl/api/Produk/${widget.produk['idProduk']}',
    );
    final request = http.MultipartRequest('PUT', uri);

    request.fields['namaProduk'] = _namaController.text;
    request.fields['harga'] = _hargaController.text;
    request.fields['stock'] = _stokController.text;
    request.fields['idKategori'] = kategoriId.toString();
    request.fields['keterangan'] = _keteranganController.text;

    try {
      if (kIsWeb && _gambarBytesWeb != null && _namaFileWeb != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'gambar',
            _gambarBytesWeb!,
            filename: _namaFileWeb,
          ),
        );
      } else if (!kIsWeb && _gambarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', _gambarFile!.path),
        );
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil diupdate")),
        );
        Navigator.pop(context, true);
      } else {
        debugPrint("Gagal update: $resBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat update")),
      );
    }
  }

  Future<int> _getIdKategoriFromNama(String nama) async {
    final item = _kategoriList.firstWhere(
      (k) => k['namaKategori'] == nama,
      orElse: () => {'idKategori': 0},
    );
    return item['idKategori'] ?? 0;
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
              onTap: _pickGambar,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Builder(
                  builder: (_) {
                    if (kIsWeb && _gambarBytesWeb != null) {
                      return Image.memory(_gambarBytesWeb!, fit: BoxFit.cover);
                    } else if (!kIsWeb && _gambarFile != null) {
                      return Image.file(_gambarFile!, fit: BoxFit.cover);
                    } else if (_urlGambarLama != null) {
                      return Image.network(
                        'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/images/${widget.produk['gambar']}',
                        fit: BoxFit.cover,
                      );
                    } else {
                      return const Center(child: Text("Upload Gambar"));
                    }
                  },
                ),
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
            _buildTextField(
              controller: _keteranganController,
              label: 'Keterangan',
              icon: Icons.description,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: _selectedKategori,
                items:
                    _kategoriList.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori['namaKategori'],
                        child: Text(kategori['namaKategori']),
                      );
                    }).toList(),
                decoration: const InputDecoration(border: InputBorder.none),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
              ),
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
                  'Simpan Perubahan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
