import 'package:flt_diagnosis_tht_certainly_firebase/ui/diagnosis_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/gejala_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/home_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/penyakit_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/role_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    
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
        return const GejalaScreen();  
      case 2:
        return const DiagnosisScreen();  
      case 3:
        return const PenyakitScreen();
      case 4:
        return const RoleScreen();  
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