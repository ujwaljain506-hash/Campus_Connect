import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
    @override
    State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmpasswordController = TextEditingController();
    final AuthService _authService = AuthService();
    
    @override
    void dispose(){
        emailController.dispose();
        passwordController.dispose();
        confirmpasswordController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Sign up'),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        TextField(
                            controller: emailController,
                            decoration:InputDecoration(
                                labelText: 'Email',
                            ),
                        ),
                        SizedBox(height:16.0),
                        TextField(
                            controller: passwordController,
                                 obscureText: true,
                            decoration:InputDecoration(
                                labelText: 'Password',
                            ),
                        ),
                        SizedBox(height:16.0),
                        TextField(
                            controller: confirmpasswordController,
                            obscureText: true,
                            decoration:InputDecoration(
                                labelText: 'Confirm Password',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                            onPressed: () async {
                                User? user = await _authService.signUp(
                                    emailController.text,
                                    passwordController.text,
                                );

                                if (user != null) {
                                    print('Signup successful: ${user.email}');
                                } else {
                                    print('Signup failed');
                                }
                            },
                            child: Text('Sign up!'),
                        ),


                    ]
                )
            )
        );
    }

}

