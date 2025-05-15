import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'edit_kategori_page.dart';
import 'tambah_kategori_page.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List<Map<String, dynamic>> kategoriList = [];

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    const apiUrl = 'https://localhost:7138/api/Kategori';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          kategoriList = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('Gagal memuat data kategori: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saat fetch data kategori: $e');
    }
  }

  Future<void> deleteKategori(int id) async {
    final apiUrl = 'https://localhost:7138/api/Kategori/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        debugPrint("Kategori berhasil dihapus");
      } else {
        debugPrint("Gagal menghapus kategori: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error saat menghapus kategori: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade50,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kategori",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: kategoriList.length,
        itemBuilder: (context, index) {
          final kategori = kategoriList[index];
          final idKategori = kategori['idKategori'];

          return Dismissible(
            key: Key(idKategori.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: Text(
                        "Yakin ingin menghapus kategori ${kategori['namaKategori']}?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Hapus"),
                        ),
                      ],
                    ),
              );
            },
            onDismissed: (direction) async {
              final namaKategori = kategori['namaKategori'];

              setState(() {
                kategoriList.removeWhere(
                  (item) => item['idKategori'] == idKategori,
                );
              });

              await deleteKategori(idKategori);

              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$namaKategori dihapus")));
            },
            child: _buildKategoriCard(kategori),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade400,
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateKategoriPage()),
          );

          if (!mounted) return;
          if (hasil != null) {
            await fetchKategori();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildKategoriCard(Map<String, dynamic> kategori) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: const Icon(Icons.category, color: Colors.deepOrange),
        title: Text(
          kategori['namaKategori'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 16,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 18, color: Colors.deepOrange),
          onPressed: () async {
            final hasil = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditKategoriPage(kategori: kategori),
              ),
            );

            if (!mounted) return;
            if (hasil != null) {
              await fetchKategori();
            }
          },
        ),
      ),
    );
  }
}
