import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'User.dart';
import 'login.dart';



class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {

  void saveUsername(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  bool hidden = true;
  bool value = false;
  bool isVisible = false;
  bool isEmpty = false;
  bool wrongFormat = false;
  var email = TextEditingController();
  var pass = TextEditingController();
  var first = TextEditingController();
  var second = TextEditingController();
  var confirm = TextEditingController();


  Widget hiddenPass(bool h,Function f)
  {
    return MaterialButton(
      onPressed: f,
      child: Icon(Icons.remove_red_eye),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Visibility(
              visible: isVisible,
              child: Container(
                child:
                Text("Wrong password", style:
                TextStyle(
                  fontSize: 15, color: Colors.red,
                ),)
                ,
              ),
            ),
            Visibility(
              visible: isEmpty,
              child: Container(
                child:
                Text("Field can't be blank", style:
                TextStyle(
                  fontSize: 15, color: Colors.red,
                ),)
                ,
              ),
            ),
            Visibility(
              visible: wrongFormat,
              child: Container(
                child:
                Text("Wrong format", style:
                TextStyle(
                  fontSize: 15, color: Colors.red,
                ),)
                ,
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: first,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'First Name',
                  hintText: 'Enter your first name..',
                  prefixIcon: Icon(Icons.edit),

                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: second,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Second Name',
                  hintText: 'Enter your second name..',
                  prefixIcon: Icon(Icons.edit),

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
                  suffixIcon: hiddenPass(hidden, (){
                    setState(() {
                      if(hidden == true)
                        hidden = false;
                      else
                        hidden = true;
                    });
                  }),


                ),
                obscureText: hidden,


              ),

            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: confirm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'confirm password',
                  hintText: 'Confirm your password..',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: hiddenPass(hidden, (){
                    setState(() {
                      if(hidden == true)
                        hidden = false;
                      else
                        hidden = true;
                    });
                  }),


                ),
                obscureText: hidden,


              ),

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: this.value,
                  onChanged: (bool value){
                    setState(() {
                      this.value = value;
                    });
                  },

                ),
                Text("I accept the terms of use & privacy policy")
              ],
            ),
            MaterialButton(onPressed: () async{
              if (pass.text == confirm.text && first.text != "" && second.text != "" &&
                  pass.text != "" && confirm.text != "") {
                var registrationData = {
                  "firstName": first.text,
                  "lastName": second.text,
                  "email": email.text,
                  "password": pass.text,
                };
                saveUsername(first.text +" "+ second.text);
                var url = Uri.parse('http://192.168.1.10:8080/auth/register');
                var response = await http.post(
                  url,
                  body: jsonEncode(registrationData),
                  headers: {'Content-Type': 'application/json'},
                );
                if (response.statusCode == 200) {
                 // Registration successful
                  Navigator.of(context).push(
                      MaterialPageRoute( //build for the route page
                          builder: (context) { //context of type build context
                            return Login();
                          }));

                }else{
                  setState(() {
                    wrongFormat = true;
                    isEmpty = false;
                    isVisible = false;

                  });
                  print('Registration failed: ${response.body}');
                }

              } else if(first.text=="" || second.text=="" || pass.text=="" || confirm.text==""){

                setState(() {
                  isEmpty = true;
                  isVisible = false;
                  wrongFormat = false;

                });
              }
              else if(pass.text != confirm.text)
              {

                setState(() {
                  isEmpty = false;
                  isVisible = true;
                  wrongFormat = false;

                });
              }

            },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.green,
              minWidth: 150,
              child: Text('signup', style: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),),
            ),


          ],
        ),
      ),
    );
  }

}