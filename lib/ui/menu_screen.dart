import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/auth/account_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/diagnosis_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/gejala_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/home_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/penyakit_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/content/role_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int currentScreen = 0;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    AppBar appBar({required String title}){
      return AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      );
    }
  
    Widget customBottomNav(){
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30),),
        child: BottomAppBar(
          child: BottomNavigationBar(
            onTap: (value){
              setState(() {             
                currentScreen = value; 
              });
            },
            type: BottomNavigationBarType.fixed, //agar background color bisa dipakai
            items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ),
                child: Icon(Icons.home, color: currentScreen == 0 ? Colors.amber : Colors.grey,),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ),
                child: Icon(Icons.local_hospital, color: currentScreen == 1 ? Colors.amber : Colors.grey,),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(                
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ),
                child: Icon(Icons.verified_user_outlined, color: currentScreen == 2 ? Colors.amber : Colors.grey,),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(                
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ),
                child: Icon(Icons.accessible, color: currentScreen == 3 ? Colors.amber : Colors.grey,),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(                
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ),
                child: Icon(Icons.accessible, color: currentScreen == 4 ? Colors.amber : Colors.grey,),
              ),
              label: '',
            ),
          ],),
        ),
      );
    }

    Widget body(){
      switch (currentScreen) {
        case 0:
          return const HomeScreen();
        case 1:
          return GejalaScreen(
            appBar: appBar(title: "Gejala Screen"),
          );  
        case 2:
          return DiagnosisScreen(
            appBar: appBar(title: "Diagnosis Screen"),
          );
        case 3:
          return PenyakitScreen(
            appBar: appBar(title: "Penyakit Screen"),
          );
        case 4:
          return RoleScreen(
            appBar: appBar(title: "Role Screen"),
          );  
        default:
          return const HomeScreen();
      }
    }

  return WillPopScope(
      onWillPop:  () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: customBottomNav(),
        body: body(),
      ),
    );
  }
}