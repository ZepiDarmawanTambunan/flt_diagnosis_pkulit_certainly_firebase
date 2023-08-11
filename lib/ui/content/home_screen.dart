import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget cardInfo(){
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Aplikasi ini memiliki 3 menu: ", 
          style: TextStyle(fontSize: 18),
          ),
          Text(
            "1. Menu Gejala: mengelola data gejala",
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          Text(
            "2. Menu Penyakit: mengelola data penyakit",
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          Text(
            "3. Menu Role: menentukan gejala pada penyakit",
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    print(auth.currentUser!.metadata);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Center(child: Text("Aplikasi diagnosa untuk penyakit kulit menggunakan metode certainty factor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.teal),textAlign: TextAlign.center,),),
            Image.asset("assets/images/healthimg.jpg", width: double.infinity, height: MediaQuery.of(context).size.height * 0.4,),
            cardInfo(),
            const Spacer(),
            const Text("By Zepi Darmawan"),
          ],
        ),
      ),
    );
  }
}