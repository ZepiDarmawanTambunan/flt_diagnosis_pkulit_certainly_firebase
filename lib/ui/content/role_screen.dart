import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/add_role_screen.dart';
import 'package:flutter/material.dart';

class RoleScreen extends StatefulWidget {
  final AppBar appBar;
  const RoleScreen({Key? key, required this.appBar}): super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final auth = FirebaseAuth.instance;
  final penyakitStore = FirebaseFirestore.instance.collection('penyakit');

    @override
  void initState() {
    super.initState();
  }

  Widget body(){
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      StreamBuilder<QuerySnapshot>(
        stream: penyakitStore.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                trailing: IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRoleScreen(kodePenyakit: snapshot.data!.docs[index]['kode'].toString(),),
                      ),
                    );
                  },
                ),
              );
            },
          ), 
        );
      }),
    ]);
  }
  
   @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: body(),
    );
  }
}