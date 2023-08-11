import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/add_gejala_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GejalaScreen extends StatefulWidget {
  final AppBar appBar;
  const GejalaScreen({Key? key, required this.appBar}): super(key: key);

  @override
  State<GejalaScreen> createState() => _GejalaScreenState();
}

class _GejalaScreenState extends State<GejalaScreen> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final kodeController = TextEditingController(); //G-N
  final namaController = TextEditingController(); //GNAME
  final gejalaStore = FirebaseFirestore.instance.collection('gejala');

  @override
  void dispose() {
    kodeController.dispose();
    namaController.dispose();
    super.dispose();
  }

  Widget popMenu(int index, AsyncSnapshot<QuerySnapshot> snapshot){
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              showMyDialog(
                kode:  snapshot.data!.docs[index]['kode']
                      .toString(),
                nama:  snapshot.data!.docs[index]['nama']
                      .toString(), 
                id:  snapshot.data!.docs[index]['id']
                      .toString(),);
            },
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              gejalaStore
                  .doc(snapshot.data!.docs[index]['id']
                      .toString())
                  .delete()
                  .then((value) {
                Utils().toastMessage(
                  message: 'Success',
                  color: Colors.green,
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(
                  message: error.toString(),
                  color: Colors.red,
                );
              });
            },
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus'),
          ),
        ),
      ],
    );
  }

  Widget floatingActionButton(){
    return FloatingActionButton(
      backgroundColor: Colors.amber,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddGejalaScreen(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: gejalaStore.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Text('Ada error!');
              }
              return Expanded(
                child: snapshot.data!.docs.isEmpty 
                ? const Text('Data kosong')
                : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]['kode'].toString()),
                      subtitle:
                          Text(snapshot.data!.docs[index]['nama'].toString()),
                      trailing: popMenu(index, snapshot),
                    );
                  },
                ), 
              );
            }),
      ]),
      floatingActionButton: floatingActionButton(),
    );
  }

  Future<void> showMyDialog({
    required String kode,
    required String nama,
    required String id
  }) async {
    kodeController.text = kode;
    namaController.text = nama;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 1,
                      controller: kodeController,
                      decoration: const InputDecoration(
                        hintText: 'Kode',
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
                      maxLines: 2,
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: 'nama',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukan gejala!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {                
                  if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                    gejalaStore.doc(id).update(
                        {'kode': kodeController.text.toString(), 'nama': namaController.text.toString()}).then((value) {
                      Utils().toastMessage(
                        message: 'Success',
                        color: Colors.green,
                      );
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(
                        message: error.toString(),
                        color: Colors.red,
                      );
                    });
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}