import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flutter/material.dart';

class AddRoleScreen extends StatefulWidget {
  final String kodePenyakit;
  const AddRoleScreen({Key? key, required this.kodePenyakit}) : super(key: key);

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final gejalaStore = FirebaseFirestore.instance.collection('gejala').snapshots();
  late Stream<QuerySnapshot> role;
  StreamSubscription<QuerySnapshot>? roleListener;
  List<Map<String, dynamic>> penyakitCfRules = [];
  List<DropdownMenuItem<double>> dropdownList = Utils().dropdownList();

  @override
  void initState() {
    super.initState();
    role = FirebaseFirestore.instance
        .collection('role')
        .where('kode_penyakit', isEqualTo: widget.kodePenyakit)
        .snapshots();
    
    roleListener = role.listen((roleSnapshot) {
      setState(() {
        penyakitCfRules = roleSnapshot.docs
            .map<Map<String, dynamic>>((roleDoc) {
              return {
                'kode_gejala': roleDoc['kode_gejala'].toString(),
                'kode_penyakit': roleDoc['kode_penyakit'].toString(),
                'params': roleDoc['params'] is int ? double.parse(roleDoc['params'].toString()) : roleDoc['params'],
                'checked': (roleDoc['checked'] ?? false) as bool,
              };
            })
            .toList();
      });
    });
  }

  @override
  void dispose() {
    roleListener?.cancel();
    super.dispose();
  }

  Widget content({
    required String kodeGejala, 
    required namaGejala, 
    required Map<String, dynamic> thisRole}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kodeGejala),
                Text(namaGejala),
                Text((thisRole.isEmpty) ? "0.0" : thisRole['params'].toString()),
              ],
            ),
          ),
          Row(
            children: [
              DropdownButton<double>(
                value: thisRole.isEmpty ? 0.0 : thisRole['params'] as double,
                onChanged: (double? value) {
                  _handleDropdownChange(params: value!, thisRole: thisRole);
                },
                items: dropdownList,
              ),
              Checkbox(
                value: thisRole['checked'] != null && thisRole['checked'],
                onChanged: (bool? value) {
                  thisRole['checked'] = value;
                  _handleCheckboxChange(thisRole: thisRole, kodeGejala: kodeGejala);
                },
              ),
            ],
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
        centerTitle: true,
        title: const Text('Add Role'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: gejalaStore,
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
                        String kodeGejala = snapshot.data!.docs[index]['kode'].toString();
                        String namaGejala = snapshot.data!.docs[index]['nama'].toString();
                        Map<String, dynamic> thisRole = penyakitCfRules.firstWhere(
                          (element) =>
                              element['kode_gejala'] == kodeGejala &&
                              element['kode_penyakit'] == widget.kodePenyakit,
                          orElse: () => {},
                        );
                        return content(
                          kodeGejala: kodeGejala,
                          namaGejala: namaGejala,
                          thisRole: thisRole,
                        );
                      },
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleDropdownChange({double params = 0.0, required Map<String, dynamic> thisRole}){
    if(thisRole['checked']){
        final roleCollection = FirebaseFirestore.instance.collection('role');
          roleCollection
          .where('kode_gejala', isEqualTo: thisRole['kode_gejala'] ?? '')
          .where('kode_penyakit', isEqualTo: thisRole['kode_penyakit'] ?? '')
          .get()
          .then((snapshot) {
          snapshot.docs.first.reference.update({
            'params': params,
          });
        setState(() {
          penyakitCfRules.where((element) =>
            element['kode_gejala'] == thisRole['kode_gejala'] &&
            element['kode_penyakit'] == widget.kodePenyakit
          ).forEach((matchingElement) {
            matchingElement['params'] = params;
          });
        });
      }).catchError((error) {
        print('Error updating/adding role: $error');
      });
    }
  }
  
  void _handleCheckboxChange({required Map<String, dynamic> thisRole, required String kodeGejala}) {
    final roleCollection = FirebaseFirestore.instance.collection('role');
    roleCollection
        .where('kode_gejala', isEqualTo: thisRole['kode_gejala'] ?? '')
        .where('kode_penyakit', isEqualTo: thisRole['kode_penyakit'] ?? '')
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.update({
          'checked': thisRole['checked'],
        });
        
      // change data in array
      setState(() {
        penyakitCfRules.where((element) =>
          element['kode_gejala'] == thisRole['kode_gejala'] &&
          element['kode_penyakit'] == widget.kodePenyakit
        ).forEach((matchingElement) {
          matchingElement['checked'] = thisRole['checked'];
        });
      });
      } else {
        roleCollection.add({
          'kode_gejala': kodeGejala,
          'kode_penyakit': widget.kodePenyakit,
          'params': 0.0,
          'checked': true,
        });
        setState(() {
          penyakitCfRules.add({
            'kode_gejala': kodeGejala,
            'kode_penyakit': widget.kodePenyakit,
            'params': 0.0,
            'checked': true,
          });
        });
      }
    }).catchError((error) {
      print('Error updating/adding role: $error');
    });
  }
}

// checked => add role
// unchecked => update
// kode_gejala | kode_penyakit | param | checked
// get gejala
// get role
// tampilkakn list gejala
// ischeck = gejala.contains(kodegejala, kodepenyakit)
// checkbox(
// value: ischeck ? 
// )