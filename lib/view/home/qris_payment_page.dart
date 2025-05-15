import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QrisPaymentPage extends StatefulWidget {
  const QrisPaymentPage({super.key});

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  File? uploadedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        uploadedImage = File(picked.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bukti transfer berhasil diunggah!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        title: const Text('Pembayaran QRIS', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // QRIS Image
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Image.asset(
                  'assets/images/qris_sample.png', // Ganti dengan QRIS Anda
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Lakukan pembayaran untuk pesanan anda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Upload Area
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    alignment: Alignment.center,
                    child: uploadedImage == null
                        ? const Text(
                            'Klik di sini untuk upload bukti transfer',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(uploadedImage!, height: 150),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (uploadedImage != null)
                const Text(
                  "Bukti transfer berhasil diunggah",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
