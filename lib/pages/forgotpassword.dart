import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:sajhabackup/pages/verification.dart';

class forgetpassword extends StatefulWidget {
  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
 final _emailController=TextEditingController();

  @override
  
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
Future passwrodReset()async{
  try{
  await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      content: Text('Password Reset link sent!!Check Your Email'),
    );
  });
  }on FirebaseAuthException catch(e){
    print(e);
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text(e.message.toString()),
      );
    });
  }
}
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25),
            child: Text('Enter your email and we will send you a link',textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            ),
          ),
        SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller:_emailController ,
              decoration: InputDecoration(
                enabledBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '...',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: passwrodReset,
            child: Text('Reset Password'),
            color: Colors.deepPurple[200],
            )
        ],
      ),
    );
  }
}

