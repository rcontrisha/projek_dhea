import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'main.dart';
import 'models/todo_model.dart';


class AddRegistrationForm extends StatefulWidget {
  const AddRegistrationForm({Key? key}) : super(key: key);

  @override
  _AddRegistrationFormState createState() => _AddRegistrationFormState();
}

class _AddRegistrationFormState extends State<AddRegistrationForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Box<TodoModel> _myBox;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Registration Form'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(
                height: 30,
              ),
              OutlinedButton(
                onPressed: () {
                  _myBox.add(TodoModel(
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ));
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
