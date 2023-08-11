import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/auth/forgot_password.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/menu_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/ui/auth/register_screen.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

    @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget form(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
              helperText: 'enter email e.g jon@gmail.com',
              prefixIcon: Icon(
                Icons.alternate_email,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              helperText: 'enter your password',
              prefixIcon: Icon(
                Icons.lock_open,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Password!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget loginInfo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text('Register now', 
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              form(),
              RoundButton(
                loading: loading,
                title: 'Login',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password', 
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              loginInfo(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

   void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MenuScreen(),
        ),
      );
    }).onError((error, stackTrace) {
      Utils().toastMessage(
        message: error.toString(),
        color: Colors.red,
      );
      setState(() {
        loading = false;
      });
    });
  }
}