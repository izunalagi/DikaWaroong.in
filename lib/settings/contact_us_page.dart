import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  String? nomorTelepon;
  String? email;
  String? alamatUrl;
  double? latitude;
  double? longitude;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContact();
  }

  Future<void> _fetchContact() async {
    final url = Uri.parse('https://localhost:7138/api/Contact');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body);
      if (dataList is List && dataList.isNotEmpty) {
        final contact = dataList.first;
        setState(() {
          nomorTelepon = contact['nomorTelepon'];
          email = contact['email'];
          alamatUrl = contact['alamat'];
          latitude = contact['latitude']?.toDouble();
          longitude = contact['longitude']?.toDouble();
          isLoading = false;
        });
      }
    } else {
      debugPrint("Gagal ambil data kontak: ${response.statusCode}");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openMaps() async {
    if (latitude != null && longitude != null) {
      final url = Uri.parse("https://maps.google.com/?q=$latitude,$longitude");
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak bisa membuka Google Maps.';
      }
    }
  }

  Widget buildInfoRow(IconData icon, Color color, String text, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 100),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng defaultLatLng = LatLng(-7.797068, 110.370529);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,
        elevation: 2,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : nomorTelepon == null
              ? const Center(child: Text("Data kontak tidak tersedia"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: const Text(
                        'Hubungi Kami',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildInfoRow(Icons.phone, Colors.green, nomorTelepon!, 0),
                    if (email != null)
                      buildInfoRow(Icons.email, Colors.green, email!, 1),
                    if (alamatUrl != null)
                      buildInfoRow(
                        Icons.location_on,
                        Colors.green,
                        alamatUrl!,
                        2,
                      ),
                    const SizedBox(height: 20),
                    if (latitude != null && longitude != null)
                      SizedBox(
                        height: 250,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(latitude!, longitude!),
                            initialZoom: 15,
                            onTap: (tapPosition, point) => _openMaps(),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(latitude!, longitude!),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (alamatUrl != null)
                      const Center(
                        child: Text(
                          'Klik peta untuk buka di Google Maps',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
