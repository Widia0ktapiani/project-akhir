import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../view_models/auth_view_model.dart';
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  File? _imageFile;
  bool _isPasswordVisible = false;

@override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final user = User(username: username, password: password);

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final result = await authViewModel.register(user, imageFile: _imageFile);

      if (result['success']) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(result['message']);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
         return AlertDialog(
        backgroundColor: const Color(0xFFB9F6CA), 
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green), 
            SizedBox(width: 10),
            const Text('Registrasi Success'),
          ],
        ),
        content: const Text('Akun Anda telah berhasil dibuat. Silakan login.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: const Text('OK', style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFEA5940),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            const Text('Registrasi Failed', style: TextStyle(color: Colors.white)),
          ],
        ),
          content: Text(message, style: const TextStyle(color: Colors.white) ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5A49B),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFF5A49B),
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 50,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF08073)
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_usernameFocusNode);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: _usernameFocusNode.hasFocus ? Color(0xFFF08073) : Color(0xFFF5A49B),
                        width: _usernameFocusNode.hasFocus ? 2.0 : 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20, color: Color(0xFFF08073)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            focusNode: _usernameFocusNode,
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              border: InputBorder.none,
                            ),
                            validator: _validateUsername,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: _passwordFocusNode.hasFocus ? Color(0xFFF08073) : Color(0xFFF5A49B),
                        width: _passwordFocusNode.hasFocus ? 2.0 : 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.lock, size: 20, color: Color(0xFFF08073)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            focusNode: _passwordFocusNode,
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xFFF08073),
                                ),
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                authViewModel.isLoading
                    ? CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () {
                          _register(context);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5A49B),
                            borderRadius: BorderRadius.circular(36.0),
                            border: Border.all(color: Color(0xFFF5A49B)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                          child: Center(
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Do You Have an Account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFFEA4937),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
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
