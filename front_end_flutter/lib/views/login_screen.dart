import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../view_models/auth_view_model.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;
      final user = User(username: username, password: password);

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final result = await authViewModel.login(user);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        _showSuccessDialog(username, result['token']);
      } else {
        _showErrorDialog();
      }
    }
  }

  void _showSuccessDialog(String username, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
       return AlertDialog(
        backgroundColor: const Color(0xFFB9F6CA), 
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            const Text('Login Success'),
          ],
        ),
        content: const Text('Welcome Back To My Bouquet'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(username: username, token: token),
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        backgroundColor: const Color(0xFFEA5940), 
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            const Text('Login Failed', style: TextStyle(color: Colors.white)),
          ],
        ),
          content: const Text('Username or Password Wrong.',style: const TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black),
            ),
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
    return Scaffold(
      backgroundColor:const Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/bunga.gif',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome To My Bouquet ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF08073),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login To Your Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEA4937),
                  ),
                ),
                const SizedBox(height: 20),
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
                _isLoading
                    ? CircularProgressIndicator()
                    : GestureDetector(
                        onTap: _login,
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
                              'SIGN IN',
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
                  children: [
                    const Text(
                      ' Dont Have an Account? ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Color(0xFFEA4937),
                          fontWeight: FontWeight.bold,
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
