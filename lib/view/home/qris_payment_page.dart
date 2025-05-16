import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QrisPaymentPage extends StatefulWidget {
  const QrisPaymentPage({super.key});

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> with SingleTickerProviderStateMixin {
  File? uploadedImage;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        uploadedImage = File(picked.path);
      });
      _animationController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bukti transfer berhasil diunggah!")),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        title: const Text('Pembayaran QRIS', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // QRIS Image with shadow and rounded corners
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/qris.jpg',
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                'Lakukan pembayaran untuk pesanan anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 48),

              // Upload Area with Dotted Border and animation
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  color: Colors.deepOrange.shade300,
                  strokeWidth: 2,
                  dashPattern: const [8, 6],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(20),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade50.withOpacity(0.4),
                    ),
                    alignment: Alignment.center,
                    child: uploadedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 50,
                                color: Colors.deepOrange.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Klik di sini untuk upload bukti transfer',
                                style: TextStyle(
                                  color: Colors.deepOrange.shade400,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  uploadedImage!,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Success message animated fade in
              if (uploadedImage != null)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Bukti transfer berhasil diunggah",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.green.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Konfirmasi Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  onPressed: uploadedImage != null ? () {
                    // TODO: Implement confirmation logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pembayaran dikonfirmasi!")),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
