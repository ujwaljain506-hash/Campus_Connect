import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_shell.dart';

class LoginScreen extends StatefulWidget {
    @override
    State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService _authService = AuthService();

    @override
    void dispose() {
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Login'),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                labelText: 'Email',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                            onPressed: () async {
                                User? user = await _authService.signIn(
                                    emailController.text,
                                    passwordController.text,
                                );

                                if (user != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeShell()),
                                    );
                                } else {
                                    print('Login failed');
                                }
                            },
                            child: Text('Login'),
                        ),
                        SizedBox(height: 16.0),
                        TextButton(
                            onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignupScreen()),
                                );
                            },
                            child: Text("Don't have an account? Sign up"),
                        ),
                    ]
                )
            )
        );
    }
}
