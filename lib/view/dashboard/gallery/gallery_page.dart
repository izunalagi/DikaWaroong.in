import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<Map<String, dynamic>> _galleryItems = [];
  final ImagePicker _picker = ImagePicker();

  final String baseUrl =
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net';

  @override
  void initState() {
    super.initState();
    fetchGallery();
  }

  Future<void> fetchGallery() async {
    final uri = Uri.parse('$baseUrl/api/Gallery');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _galleryItems.clear();
        for (var item in data) {
          final id = item['idGallery'];
          final foto = item['fotoGallery'];
          if (foto != null) {
            final url = '$baseUrl/gallery/$foto';
            _galleryItems.add({'id': id, 'image': null, 'url': url});
            final index = _galleryItems.length - 1;
            _loadNetworkImage(url, index);
          }
        }
        setState(() {});
      } else {
        debugPrint("Gagal fetch: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetch gallery: $e");
    }
  }

  Future<void> _loadNetworkImage(String url, int index) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _galleryItems[index]['image'] = response.bodyBytes;
        });
      }
    } catch (e) {
      debugPrint("Gagal load image: $e");
    }
  }

  Future<void> _pickImage(int index) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Ambil dari Kamera"),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Pilih dari Galeri"),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );

    if (source != null) {
      try {
        // Perbaikan untuk kamera: pastikan kualitas dan imageQuality diatur
        final picked = await _picker.pickImage(
          source: source,
          imageQuality: source == ImageSource.camera ? 85 : null, // Kompres foto kamera
          maxWidth: source == ImageSource.camera ? 1920 : null, // Batasi ukuran foto kamera
          maxHeight: source == ImageSource.camera ? 1080 : null,
        );
        
        if (picked != null) {
          // Show loading indicator
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text("Mengupload gambar..."),
                  ],
                ),
                duration: Duration(seconds: 10),
              ),
            );
          }

          final bytes = await picked.readAsBytes();
          String fileName = picked.name;
          
          // Perbaikan nama file untuk foto kamera
          if (source == ImageSource.camera && (fileName.isEmpty || fileName == 'image_picker_${DateTime.now().millisecondsSinceEpoch}.jpg')) {
            fileName = 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
          }

          debugPrint("File name: $fileName, Size: ${bytes.length} bytes");

          // Update UI terlebih dahulu untuk preview
          setState(() {
            _galleryItems[index]['image'] = bytes;
          });

          // Upload ke server
          await _uploadImage(bytes, fileName, index);
        }
      } catch (e) {
        debugPrint("Error saat pick image: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error mengambil gambar: $e")),
          );
        }
      }
    }
  }

  Future<void> _uploadImage(List<int> bytes, String fileName, int index) async {
    try {
      final uri = Uri.parse('$baseUrl/api/Gallery');
      final request = http.MultipartRequest('POST', uri);
      
      // Tentukan content type berdasarkan ekstensi file
      MediaType contentType = MediaType('image', 'jpeg');
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = MediaType('image', 'png');
      } else if (fileName.toLowerCase().endsWith('.gif')) {
        contentType = MediaType('image', 'gif');
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'fotoGallery',
          bytes,
          filename: fileName,
          contentType: contentType,
        ),
      );

      // Tambahkan headers jika diperlukan
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      debugPrint("Uploading to: $uri");
      debugPrint("File: $fileName (${bytes.length} bytes)");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      debugPrint("Upload response: ${response.statusCode}");
      debugPrint("Response body: $responseBody");

      if (!mounted) return;

      // Hide loading snackbar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload berhasil"),
            backgroundColor: Colors.orange,
          ),
        );
        // Refresh gallery untuk mendapatkan data terbaru
        await fetchGallery();
      } else {
        // Rollback preview jika upload gagal
        setState(() {
          if (index < _galleryItems.length && _galleryItems[index]['id'] == null) {
            _galleryItems[index]['image'] = null;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload gagal: ${response.statusCode}\n$responseBody"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      if (!mounted) return;
      
      // Hide loading snackbar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      
      // Rollback preview jika upload gagal
      setState(() {
        if (index < _galleryItems.length && _galleryItems[index]['id'] == null) {
          _galleryItems[index]['image'] = null;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error upload: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _confirmDelete(int index) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Konfirmasi Hapus"),
                content: const Text("Yakin ingin menghapus gambar ini?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Hapus"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _deleteImage(int index) async {
    final id = _galleryItems[index]['id'];
    final uri = Uri.parse('$baseUrl/api/Gallery/$id');

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        // Delay penghapusan untuk cegah error Dismissible
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
        setState(() {
          _galleryItems.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gambar berhasil dihapus")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal hapus: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal hapus: $e")));
    }
  }

  Widget _buildImageField(int index) {
    final image = _galleryItems[index]['image'];

    return Dismissible(
      key: UniqueKey(), // Supaya tidak bentrok di list
      direction: DismissDirection.horizontal,
      confirmDismiss: (_) => _confirmDelete(index),
      onDismissed: (_) => _deleteImage(index),
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
      child: GestureDetector(
        onTap: () => _pickImage(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(16),
            color: Colors.orange.shade50,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox.expand(
              child:
                  image != null
                      ? Image.memory(image, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 40, color: Colors.orange),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddField() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _galleryItems.add({'id': null, 'image': null, 'url': null});
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
    final itemCount = _galleryItems.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
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
            if (index < _galleryItems.length) {
              return _buildImageField(index);
            } else {
              return _buildAddField();
            }
          },
        ),
      ),
    );
  }
}