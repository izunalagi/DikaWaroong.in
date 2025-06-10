import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class QrisPaymentPage extends StatefulWidget {
  final int idTransaksi;
  const QrisPaymentPage({super.key, required this.idTransaksi});

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  Uint8List? selectedImageBytes;
  String? selectedImageName;
  bool isUploaded = false;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          selectedImageBytes = bytes;
          selectedImageName = picked.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal pilih gambar: $e')));
    }
  }

  Future<void> _uploadImage() async {
    if (selectedImageBytes == null || selectedImageName == null) return;

    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse(
      'https://localhost:7138/api/Transaksi/${widget.idTransaksi}',
    );

    var request = http.MultipartRequest('PUT', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'BuktiTF',
        selectedImageBytes!,
        filename: selectedImageName!,
        contentType: MediaType(
          'image',
          'jpeg',
        ), // Bisa disesuaikan jika PNG dll
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          isUploaded = true;
          isUploading = false;
          // jangan reset selectedImageBytes dan selectedImageName biar preview tetap muncul
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bukti transfer berhasil diunggah')),
        );
      } else {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload gagal: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat upload: $e')));
    }
  }

  Widget _buildImageUploadArea() {
    return GestureDetector(
      onTap: isUploaded ? null : _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade50.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.deepOrange.shade400, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.shade200.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child:
            selectedImageBytes == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.deepOrange.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Klik di sini untuk upload bukti transfer",
                      style: TextStyle(
                        color: Colors.deepOrange.shade300,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                : Image.memory(
                  selectedImageBytes!,
                  fit: BoxFit.contain,
                  height: 170,
                  width: double.infinity,
                ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    if (isUploaded) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text(
          "Bukti TF sudah terkirim",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed:
          (selectedImageBytes != null && !isUploading) ? _uploadImage : null,
      icon:
          isUploading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
              : const Icon(Icons.upload),
      label: Text(
        isUploading ? "Sedang mengunggah..." : "Konfirmasi Pembayaran",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size.fromHeight(52),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Pembayaran QRIS",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/qris.jpg",
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Lakukan pembayaran untuk pesanan anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 36),
              _buildImageUploadArea(),
              const SizedBox(height: 40),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }
}
