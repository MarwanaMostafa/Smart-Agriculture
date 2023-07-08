import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidden = true;
  var email = TextEditingController();
  var pass = TextEditingController();
  bool isVisible = false;

  void saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Widget hiddenPass(bool h, Function f) {
    return MaterialButton(
      onPressed: f,
      child: Icon(Icons.remove_red_eye),
    );
  }

  Future<bool> loginUser(String email, String password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    var url = Uri.parse('http://192.168.1.10:8080/auth/login');
    var response = await http.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status code: ${response.statusCode}');


    if (response.statusCode == 200) {
      // Login successful
      var user = User(username,email, password: password,);
      User.setCurrentUser(user); // Set as the current user
      saveCredentials(email, password);
      return true;
    } else {
      // Login failed
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isVisible,
            child: Container(
              child: Text(
                "Wrong email or password",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: email,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'email',
                hintText: 'Enter valid email..',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: pass,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'password',
                hintText: 'Enter password..',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: hiddenPass(hidden, () {
                  setState(() {
                    hidden = !hidden;
                  });
                }),
              ),
              obscureText: hidden,
            ),
          ),
          MaterialButton(
            onPressed: () async {
              isVisible = true;
              setState(() {});

              var loginSuccessful = await loginUser(email.text, pass.text);

              if (loginSuccessful) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage(user: User.getCurrentUser());
                    },
                  ),
                );
              } else {
                isVisible = true;
              }

              setState(() {});
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.green,
            minWidth: 150,
            child: Text(
              'login',
              style: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Signup();
                      },
                    ),
                  );
                },
                child: Text(
                  "click here",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
