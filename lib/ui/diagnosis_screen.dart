import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/services/diagnosis_services.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/detail_penyakit_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final gejalaStore = FirebaseFirestore.instance.collection('gejala').snapshots();
  final auth = FirebaseAuth.instance;
  final List<Map<String, dynamic>> answerChoices = [
    {'text': 'Tidak', 'value': 0.0},
    {'text': 'Tidak Tahu', 'value': 0.2},
    {'text': 'Sedikit Yakin', 'value': 0.4},
    {'text': 'Cukup Yakin', 'value': 0.6},
    {'text': 'Yakin', 'value': 0.8},
    {'text': 'Sangat Yakin', 'value': 1.0},
  ];
  final Map<String, double> _selectedValues = {};

  List<Widget> buildAnswerChoices(String kodeGejala) {
    return answerChoices.map((answerChoice) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                  ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: SizedBox(
                width: Checkbox.width,
                height: Checkbox.width,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.transparent,
                    ),
                    child: Checkbox(
                      value: _selectedValues[kodeGejala] == answerChoice['value'],
                      onChanged: (value) => _handleValueChanged(kodeGejala, answerChoice['value']!),
                      activeColor: Colors.transparent,
                      checkColor: _selectedValues[kodeGejala] == answerChoice['value'] ? Colors.purple : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Text(answerChoice['text']!),
          ],
        ),
      );
    }).toList();
  }

  AppBar appBar(){
    return AppBar(
      backgroundColor: Colors.green,
      centerTitle: true,
      title: const Text('Diagnosis Screen'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: gejalaStore,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            }
            if (snapshot.hasError) {
              return const Text('Ada error!');
            }
            return snapshot.data!.docs.isEmpty 
                ? const Text('Data kosong')
                : ListView.builder(
                itemCount: snapshot.data!.docs.length +1,
                itemBuilder: (context, index) {
                    return index == snapshot.data!.docs.length ?
                      RoundButton(
                        title: "Kirim", 
                        onTap: () {
                          DiagnosisService.getDiagnosis(values: _selectedValues, context: context).then((Map<String, dynamic>value){
                              showDialogDiagnosis(penyakitList: value['message'] as List<Map<String, dynamic>>);
                              setState(() {
                                _selectedValues.clear();
                              });
                            }).catchError((error){
                            print(error);
                          });
                        }, 
                        loading: false,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. Apakah anda yakin mengalami gejala ${snapshot.data!.docs[index]['nama'].toString()}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: buildAnswerChoices(snapshot.data!.docs[index]['kode']),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
          }
        ),
      ),
    );
  }

  void showDialogDiagnosis({required List<Map<String, dynamic>>penyakitList}){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil penyakit yang kemungkinan anda alami'),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: penyakitList.length+1,
                itemBuilder: (context, index) {
                  return index == penyakitList.length 
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text("catatan: perhitungan diatas didapat dari jawaban yang anda berikan kemudian dihitung menggunakan metode certianly factor sistem pakar (kemungkinan), Tetap direkomendasikan untuk berkonsultasi langsung kepada dokter", 
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : GestureDetector(
                    onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPenyakitScreen(
                          penyakit: penyakitList[index]
                        ),
                      ),
                    );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("${index+1}. Penyakit ${penyakitList[index]['nama']}: ${double.parse("${penyakitList[index]['cm']}").toStringAsFixed(2)}%"),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleValueChanged(String kodeGejala, double value) {
    setState(() {
      _selectedValues[kodeGejala] = value;
    });
  }
}
