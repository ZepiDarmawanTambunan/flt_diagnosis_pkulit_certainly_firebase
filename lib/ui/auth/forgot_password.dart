import 'package:firebase_auth/firebase_auth.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/utils/utils.dart';
import 'package:flt_diagnosis_tht_certainly_firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                height: 40,
              ),
              RoundButton(
                  title: 'Forgot',
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    _auth
                        .sendPasswordResetEmail(email: emailController.text)
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(
                        message:
                            'We have sent you email to recovery password, please check your email',
                        color: Colors.green,
                      );
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(
                        message: error.toString(),
                        color: Colors.red,
                      );
                    });
                  },
                  loading: loading)
            ]),
      ),
    );
  }
}