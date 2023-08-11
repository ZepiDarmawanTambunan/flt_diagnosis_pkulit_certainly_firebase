import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/auth/login_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  String? _imageProfile;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final usersStore = FirebaseFirestore.instance.collection('users');

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  Future<void> _fetchImageProfile() async {
    DocumentSnapshot<Map<String, dynamic>> userData =
        await usersStore.doc(auth.currentUser!.uid).get();
    if (userData.exists && userData.data()!.containsKey('image_profile')) {
      setState(() {
        _imageProfile = userData['image_profile'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchImageProfile();
    print(_imageProfile);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Account Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : (_imageProfile != null) ? Image.network(_imageProfile!)
                      : const Center(
                          child: Icon(Icons.image),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Upload',
              onTap: () async {
                if(_image != null){
                  editAccount();
                }
              },
              loading: loading
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editAccount(){
    setState(() {
      loading = true;
    });

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/images/${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask =
        ref.putFile(_image!.absolute);

    Future.value(uploadTask).then((value) async {
      var newURL = await ref.getDownloadURL();
      usersStore.doc(auth.currentUser!.uid).set({
        'image_profile':newURL.toString()
      }).then((value) {
        setState(() {
          loading = false;
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
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(
        message: error.toString(),
        color: Colors.red,
      );
    });
  }
}