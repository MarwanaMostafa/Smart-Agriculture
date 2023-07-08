import 'package:flutter/material.dart';

class User extends StatelessWidget {
   String username;
   String email;

  String password;

  String getCurrentUsername()
  {
    return this.username;
  }
  String getCurrentEmail()
  {
    return this.email;
  }
  User(this.username, this.email, {this.password});

   static User _currentUser;

   static User getCurrentUser() {
     return _currentUser;
   }

   static void setCurrentUser(User user) {
     _currentUser = user;
   }

   static void clearCurrentUser() {
     _currentUser = null;
   }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}