import 'package:flutter/material.dart';

class DetailPenyakitScreen extends StatelessWidget {
  final Map<String, dynamic> penyakit;

  const DetailPenyakitScreen({required this.penyakit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Detail Penyakit Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama Penyakit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  penyakit['nama'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Divider(height: 24),
                const Text(
                  "Penyebab Penyakit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  penyakit['penyebab'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Divider(height: 24),
                const Text(
                  "Cara Mengobati Penyakit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  penyakit['pengobatan'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}