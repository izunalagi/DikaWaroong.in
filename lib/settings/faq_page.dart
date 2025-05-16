import 'package:flutter/material.dart';
import 'dart:async';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'Bagaimana cara memesan makanan?',
        'answer':
            'Pilih menu yang diinginkan, klik "Tambah ke Keranjang", lalu checkout.'
      },
      {
        'question': 'Metode pembayaran apa yang tersedia?',
        'answer':
            'Kami menerima pembayaran melalui QRIS, transfer bank, dan tunai.'
      },
      {
        'question': 'Apakah saya bisa membatalkan pesanan?',
        'answer':
            'Pesanan hanya bisa dibatalkan sebelum statusnya diproses.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.orange.shade700,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return DelayedAnimatedFAQTile(
            question: faq['question']!,
            answer: faq['answer']!,
            delayMilliseconds: index * 150,
          );
        },
      ),
    );
  }
}

class DelayedAnimatedFAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final int delayMilliseconds;

  const DelayedAnimatedFAQTile({
    super.key,
    required this.question,
    required this.answer,
    this.delayMilliseconds = 0,
  });

  @override
  State<DelayedAnimatedFAQTile> createState() => _DelayedAnimatedFAQTileState();
}

class _DelayedAnimatedFAQTileState extends State<DelayedAnimatedFAQTile> {
  bool _visible = false;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Transform.translate(
        offset: _visible ? Offset.zero : const Offset(0, 30),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              trailing: Icon(
                _expanded ? Icons.remove_circle : Icons.add_circle,
                color: Colors.orange.shade700,
              ),
              onExpansionChanged: (expanded) {
                setState(() => _expanded = expanded);
              },
              title: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Text(
                  widget.answer,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
