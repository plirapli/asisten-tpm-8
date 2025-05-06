import 'package:asisten_tpm_8/models/user_model.dart';
import 'package:asisten_tpm_8/pages/home_page.dart';
import 'package:asisten_tpm_8/services/user_service.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? _gender;

  Future<void> _createUser(BuildContext context) async {
    String msg = "";
    try {
      UserModel newUser = UserModel(
        name: _name.text.trim(),
        email: _email.text.trim(),
        gender: _gender,
      );

      final Map<String, dynamic> response = await UserApi.createUser(newUser);
      final status = response["status"];
      msg = response["message"];

      if (status == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: Duration(seconds: 2)),
        );

        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        throw Exception(msg);
      }
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create User"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text("Gender"),
            Row(
              spacing: 4,
              children: [
                Radio(
                  value: "Male",
                  groupValue: _gender,
                  onChanged: (event) {
                    setState(() {
                      _gender = event;
                    });
                    print(_gender);
                  },
                ),
                Text("Male"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 4,
              children: [
                Radio(
                  value: "Female",
                  groupValue: _gender,
                  onChanged: (event) {
                    setState(() {
                      _gender = event;
                    });
                    print(_gender);
                  },
                ),
                Text("Female"),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createUser(context);
              },
              child: const Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
