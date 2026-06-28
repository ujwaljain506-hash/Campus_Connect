import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
    @override
    State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    @override
    void dipose() {
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
                            onPressed: (){
                                //login logic here for later
                            },
                            child: Text('Login'),
                        ),
                        SizedBox(height: 16.0),
                        TextButton(
                            onPressed: (){},
                            child: Text("Don't have an account? Sign up"),
                        ),
                    ]
                )
            )
        );
    }
}
