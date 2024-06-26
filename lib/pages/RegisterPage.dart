import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Splashes/splashpage.dart';
import 'package:sajhabackup/pages/login.dart';
import 'package:sajhabackup/utils/toast.dart';

class RegisterPage extends StatefulWidget {
  final String phone;
  const RegisterPage({Key? key, required this.phone}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  //TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  XFile? _pickedImage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false; // Added this variable

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _register() async {
    try {
      if (_validateForm()) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        String userId = userCredential.user!.uid;

        if (_pickedImage != null) {
          await _uploadProfilePicture(userId);
        }

        await _firestore.collection('users').doc(userId).set({
          'Full Name': _fullNameController.text,
          'Address': _addressController.text,
          'Username': _usernameController.text,
          'Phone': widget.phone,
          'Email': _emailController.text,
          'Password': _passwordController.text,
          'ProfilePicUrl':
              _pickedImage != null ? await _getProfilePicUrl(userId) : null,
          'uid': userId,
        });

        await userCredential.user!.sendEmailVerification();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
        );
        showToast(message: 'Successfully Registerd');

        print('Registration successful');
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  Future<String?> _getProfilePicUrl(String userId) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('profile_pic/$userId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting profile picture URL: $e');
      return null;
    }
  }

  Future<void> _uploadProfilePicture(String userId) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pic/$userId.jpg');
      await storageReference.putFile(
        File(_pickedImage!.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  bool _validateForm() {
    if (_fullNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        (_pickedImage == null)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/register.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(File(_pickedImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16)),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16)),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16)),
                ),
                SizedBox(height: 15.0),
                /*TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16)),
                ),*/
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16)),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: regular,
                          fontSize: 16),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(_isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                ),
                SizedBox(height: 30.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), color: color),
                  child: TextButton(
                    onPressed: _register,
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 18, fontFamily: regular, color: color1),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have an account?',
                      style: TextStyle(
                          fontFamily: regular,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    SizedBox(width: 1),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginscreen()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
