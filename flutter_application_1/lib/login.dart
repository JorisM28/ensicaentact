import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard_screen.dart';


const user_test = {
    'toto@ecole.ensicaen.fr': '1234',
    'beubeu@ecole.ensicaen.fr': '5678'
    };


void main() {
    runApp(MyApp());
}

class MyApp() extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Login(),
        );
    }
}

class Login extends StatefulWidget {
    @override
    _LoginState creatState() =>  LoginState();
}

class LoginState extends State<Login> {
    @override
    Widget build(BuildContext context) {

    }
}