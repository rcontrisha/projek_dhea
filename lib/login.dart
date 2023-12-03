import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'add_todo.dart';
import 'home.dart';
import 'main.dart';
import 'models/todo_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late Box<TodoModel> _myBox;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form"),
      ),
      body: ValueListenableBuilder(
        valueListenable: _myBox.listenable(),
        builder: (BuildContext context, value, _) {
          if (_myBox.values.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Registrations are empty. Please register first."),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the registration form
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AddRegistrationForm();
                          }));
                    },
                    child: Text(
                      "Register here",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.jpg', // Ganti dengan path gambar Anda
                        height: 100, // Sesuaikan dengan tinggi yang diinginkan
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement logic to check login credentials
                    if (checkLoginCredentials(
                        _usernameController.text, _passwordController.text)) {
                      // Navigate to the home page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return HomePage(username: _usernameController.text);
                        }),
                      );
                    } else {
                      // Show error message for invalid login
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Invalid login credentials"),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to the registration form
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return AddRegistrationForm();
                        }));
                  },
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool checkLoginCredentials(String enteredUsername, String enteredPassword) {
    for (var i = 0; i < _myBox.length; i++) {
      TodoModel? res = _myBox.getAt(i);
      if (res!.username == enteredUsername &&
          res.password == enteredPassword) {
        return true;
      }
    }
    return false;
  }
}
