import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/add_penyakit_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/login_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flutter/material.dart';

class PenyakitScreen extends StatefulWidget {
  const PenyakitScreen({super.key});

  @override
  State<PenyakitScreen> createState() => _PenyakitScreenState();
}

class _PenyakitScreenState extends State<PenyakitScreen> {
  final auth = FirebaseAuth.instance;
  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('penyakit').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('penyakit');

  @override
  void dispose() {
    kodeController.dispose();
    namaController.dispose();
    super.dispose();
  }

  AppBar appBar(){
    return AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text('Penyakit Screen'),
      actions: [
        IconButton(
          onPressed: () {
            auth.signOut().then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }).onError((error, stackTrace) {
              Utils().toastMessage(
                message: error.toString(),
                color: Colors.red,
              );
            });
          },
          icon: const Icon(Icons.logout_outlined),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
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
                    snapshot.data!.docs[index]['kode']
                        .toString(),
                    snapshot.data!.docs[index]['nama']
                        .toString(), 
                    snapshot.data!.docs[index]['id']
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
                ref.doc(snapshot.data!.docs[index]['id']
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: fireStore,
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
                child: snapshot.data!.docs.length <= 0 
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPenyakitScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String kode, String nama, String id) async {
    kodeController.text = kode;
    namaController.text = nama;

    return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update'),
        content: Container(
          child: Column(
            children: [
              TextField(
                controller: kodeController,
                decoration: const InputDecoration(
                  hintText: 'Kode',
                ),
              ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  hintText: 'nama',
                ),
              ),
            ],
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
              Navigator.pop(context);
              ref.doc(id).update(
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
            },
            child: const Text('Update'),
          ),
        ],
      );
    });
  }
}