import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiagnosisService{
  static Future<Map<String, dynamic>> getDiagnosis({required Map<String, double> values, required BuildContext context}) async {
    try {
      // GET DATA TO FIREBASE
      CollectionReference<Map<String, dynamic>> roleCollection = FirebaseFirestore.instance.collection('role');
      CollectionReference<Map<String, dynamic>> penyakitCollection = FirebaseFirestore.instance.collection('penyakit');
      QuerySnapshot<Map<String, dynamic>> roleSnapshot = await roleCollection.get();
      QuerySnapshot<Map<String, dynamic>> penyakitSnapshot = await penyakitCollection.get();
      
      List<Map<String, dynamic>> roleList = roleSnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
      List<Map<String, dynamic>> penyakitList = penyakitSnapshot.docs.map((docSnapshot) {
        
        // penyakit => [{ 'kode': 'P-1', 'kode_gejala': {'G-1': 0.2 'G-2': 0.4} }] cf rules
        // filter gejala yang checked dan memiliki nilai params
        final penyakitItem = docSnapshot.data();
        penyakitItem['kode_gejala'] = {};
        roleList.forEach((element) {
          if(element['kode_penyakit'] == penyakitItem['kode'] && element['checked'] == true && element['params'] != null){
            penyakitItem['kode_gejala'][element['kode_gejala']] = element['params'];
          }
        });

        // cfSample = values {'G-1': 0.3 * penyakitItem['G-1'], 'G-2': 0.8 * penyakitItem['G-1'], 'G-3': 0.5 * penyakitItem['G-1']}
        Map<String, dynamic> cfSample = {};
        values.forEach((key, value) {          
          var cfrule = penyakitItem['kode_gejala'][key];
          if(cfrule != null){
            cfSample[key] = value * cfrule;
          }
        });

        // convert cfSample {'G-1': 0.5, 'G-3': 0.3, 'G-2': 0.8} to [0.5, 0.8, 0.3]
        List<MapEntry<String, dynamic>> entries = cfSample.entries.toList();
        entries.sort((a, b) {
          int aNum = int.parse(a.key.substring(2)); // Mengambil angka setelah 'G-'
          int bNum = int.parse(b.key.substring(2)); // Mengambil angka setelah 'G-'
          return aNum.compareTo(bNum);
        });
        List cf = entries.map((entry) => entry.value).toList();

        // print(cfSample);
        // menghitung combine
        penyakitItem['cm'] = cf.length == 1 ? cf[0] : 0;
        if(cf.length >= 2){
          for (int i = 0; i<cf.length; i++) {
            if(i==0){
              penyakitItem['cm'] = cf[i] + cf[i+1] * (1-cf[i]);
            }else{
              if(i == 1){
                continue;
              }
              // print("step ${i+1}: ${penyakitItem['cm']} + ${cf[i]} * ${1-cf[i]}");
              penyakitItem['cm'] += cf[i] * (1 - penyakitItem['cm']);
            }
          }
        }

        // print(penyakitItem['cm']);
        penyakitItem['cm'] *= 100;
        return penyakitItem;
      }).toList();
      // Mengurutkan berdasarkan properti "cm" dari terbesar ke terkecil
      print(penyakitList);
      penyakitList.sort((a, b) {
        double cmA = a["cm"] is int ? (a["cm"] as int).toDouble() : a["cm"] as double;
        double cmB = b["cm"] is int ? (b["cm"] as int).toDouble() : b["cm"] as double;
        return cmB.compareTo(cmA);
      });
      return {"message": penyakitList,"status": true};
    } catch (e) {
      return {"message": 'Error saat mengambil data: $e', "status": false};
    }
  }
}