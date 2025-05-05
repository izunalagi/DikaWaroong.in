import 'package:flutter/material.dart';
import 'edit_produk_page.dart';
import 'tambah_produk_page.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Map<String, dynamic>> produkList = [
    {
      'nama': 'Ayam Geprek',
      'detail': '10000',
      'stok': 2,
      'kategori': 'Makanan',
      'gambar': null,
    },
    {
      'nama': 'Gurame',
      'detail': '15000',
      'stok': 5,
      'kategori': 'Makanan',
      'gambar': null,
    },
    {
      'nama': 'Es Teh',
      'detail': '5000',
      'stok': 10,
      'kategori': 'Minuman',
      'gambar': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade50,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Produk",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final item = produkList[index];
          return Dismissible(
            key: Key(item['nama']),
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
                builder: (context) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: Text("Yakin ingin menghapus ${item['nama']}?"),
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
            onDismissed: (direction) {
              setState(() {
                produkList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${item['nama']} dihapus")),
              );
            },
            child: _buildProdukCard(index, item),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade400,
        onPressed: () async {
          final produkBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahProdukPage()),
          );

          if (produkBaru != null) {
            setState(() {
              produkList.add(produkBaru);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProdukCard(int index, Map<String, dynamic> produk) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.shopping_bag, color: Colors.white),
        ),
        title: Text(
          produk['nama'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rp ${produk['detail']} | Stok: ${produk['stok']}",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              produk['kategori'] ?? 'Lainnya',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 18, color: Colors.deepOrange),
          onPressed: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProdukPage(produk: produk),
              ),
            );

            if (updated != null) {
              setState(() {
                produkList[index] = updated;
              });
            }
          },
        ),
      ),
    );
  }
}
