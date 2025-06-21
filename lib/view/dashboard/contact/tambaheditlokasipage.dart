import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'web_map_widget.dart';

class TambahEditLokasiPage extends StatefulWidget {
  const TambahEditLokasiPage({super.key});

  @override
  State<TambahEditLokasiPage> createState() => _TambahEditLokasiPageState();
}

class _TambahEditLokasiPageState extends State<TambahEditLokasiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  LatLng? _selectedLatLng;
  int? _contactId;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final url = Uri.parse(
      'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Contact',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body);
      if (dataList is List && dataList.isNotEmpty) {
        final contact = dataList.first;
        _contactId = contact['id'];
        _teleponController.text = contact['nomorTelepon'] ?? '';
        _emailController.text = contact['email'] ?? '';
        final lat = contact['latitude'];
        final lng = contact['longitude'];
        if (lat != null && lng != null) {
          setState(() {
            _selectedLatLng = LatLng(lat, lng);
          });
        }
      }
    } else {
      debugPrint("Gagal memuat kontak: ${response.statusCode}");
    }
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate() && _selectedLatLng != null) {
      final body = jsonEncode({
        "id": _contactId ?? 1, // <- WAJIB ADA
        "nomorTelepon": _teleponController.text,
        "email": _emailController.text,
        "alamat":
            "https://maps.google.com/?q=${_selectedLatLng!.latitude},${_selectedLatLng!.longitude}",
        "latitude": _selectedLatLng!.latitude,
        "longitude": _selectedLatLng!.longitude,
        "createdAt": DateTime.now().toIso8601String(), // <- Tambahkan ini
      });

      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse(
        'https://dikawaroongin-bsawefdmg5gfdvay.canadacentral-01.azurewebsites.net/api/Contact',
      );

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Berhasil disimpan")));
        Navigator.pop(context, true);
      } else {
        debugPrint("Gagal simpan: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal simpan: ${response.statusCode}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lokasi Kontak"),
        backgroundColor: Colors.orange.shade400,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: WebMapWidget(
                selectedLatLng: _selectedLatLng,
                onTap: (latLng) {
                  setState(() {
                    _selectedLatLng = latLng;
                  });
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _teleponController,
                      decoration: const InputDecoration(
                        labelText: "Nomor Telepon",
                      ),
                      validator:
                          (value) => value!.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator:
                          (value) => value!.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _simpanData,
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
