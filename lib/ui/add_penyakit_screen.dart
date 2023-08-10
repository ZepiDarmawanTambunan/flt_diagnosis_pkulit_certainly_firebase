import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPenyakitScreen extends StatefulWidget {
  const AddPenyakitScreen({Key? key}) : super(key: key);

  @override
  State<AddPenyakitScreen> createState() => _AddPenyakitScreenState();
}

class _AddPenyakitScreenState extends State<AddPenyakitScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final kodeController = TextEditingController(); // P-N
  final penyakitController = TextEditingController(); // PNAME
  final penyebabController = TextEditingController(); // PENYEBAB
  final pengobatanController = TextEditingController(); // PENGOBATAN
  final penyakitStore = FirebaseFirestore.instance.collection('penyakit');

  @override
  void dispose() {
    kodeController.dispose();
    penyakitController.dispose();
    penyebabController.dispose();
    pengobatanController.dispose();
    super.dispose();
  }

  Widget form(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            maxLines: 1,
            controller: kodeController,
            decoration: const InputDecoration(
              hintText: 'kode',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukan kode!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 1,
            controller: penyakitController,
            decoration: const InputDecoration(
              hintText: 'penyakit',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukan penyakit!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 5,
            controller: penyebabController,
            decoration: const InputDecoration(
              hintText: 'penyebab',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukan penyebab!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 5,
            controller: pengobatanController,
            decoration: const InputDecoration(
              hintText: 'Cara mengobati',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukan cara mengobati!';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Penyakit'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            form(),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  addPenyakit();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void addPenyakit(){
    setState(() {
      loading = true;
    });
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    penyakitStore.doc(id).set({
      'id': id,
      'kode': kodeController.text.toString(),
      'nama': penyakitController.text.toString(),
    }).then((value) {
      setState(() {
        loading = false;
        kodeController.text = "";
        penyakitController.text = "";
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
  }
}