import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddGejalaScreen extends StatefulWidget {
  const AddGejalaScreen({Key? key}) : super(key: key);

  @override
  State<AddGejalaScreen> createState() => _AddGejalaScreenState();
}

class _AddGejalaScreenState extends State<AddGejalaScreen> {
  bool loading = false;
  final kodeController = TextEditingController();
  final gejalaController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('gejala');

  @override
  void dispose() {
    kodeController.dispose();
    gejalaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Gejala'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: kodeController,
              decoration: const InputDecoration(
                hintText: 'kode',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLines: 4,
              controller: gejalaController,
              decoration: const InputDecoration(
                hintText: 'gejala',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'id': id,
                  'kode': kodeController.text.toString(),
                  'nama': gejalaController.text.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                    kodeController.text = "";
                    gejalaController.text = "";
                  });
                  Utils().toastMessage(
                    message: 'Success',
                    color: Colors.green,
                  );
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(
                    message: 'Success',
                    color: Colors.red,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}