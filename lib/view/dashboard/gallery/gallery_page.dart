import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<File?> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _images[index] = File(picked.path);
      });
    }
  }

  Future<bool> _confirmDelete(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Yakin ingin menghapus gambar ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  Widget _buildImageField(int index) {
    final image = _images[index];
    final isFilled = image != null;

    return Dismissible(
      key: Key('field_$index'),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(index),
      onDismissed: (_) {
        setState(() {
          _images.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Field gambar dihapus")),
        );
      },
      child: GestureDetector(
        onTap: () => _pickImage(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(16),
            color: Colors.orange.shade50,
          ),
          child: Center(
            child: isFilled
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : const Icon(Icons.image, size: 40, color: Colors.orange),
          ),
        ),
      ),
    );
  }

  Widget _buildAddField() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _images.add(null); // Tambah field kosong
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(16),
          color: Colors.orange.shade100,
        ),
        child: const Center(
          child: Icon(Icons.add, size: 40, color: Colors.deepOrange),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _images.length + 1; // +1 untuk tombol tambah

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < _images.length) {
              return _buildImageField(index);
            } else {
              return _buildAddField(); // field terakhir sebagai tombol tambah
            }
          },
        ),
      ),
    );
  }
}
