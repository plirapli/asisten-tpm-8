import 'package:asisten_tpm_8/models/user_model.dart';
import 'package:asisten_tpm_8/pages/create_user_page.dart';
import 'package:asisten_tpm_8/pages/edit_user_page.dart';
import 'package:asisten_tpm_8/services/user_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data User")),
      body: Container(padding: EdgeInsets.all(20), child: _userContainer()),
    );
  }

  Widget _userContainer() {
    return FutureBuilder(
      future: UserApi.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        } else if (snapshot.hasData) {
          UsersModel usersModel = UsersModel.fromJson(snapshot.data!);
          return _userList(context, usersModel.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _userList(BuildContext context, List<UserModel> users) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const CreateUserPage(),
              ),
            );
          },
          child: Text("Create New User"),
        ),
        for (var user in users)
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.green.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(user.name!),
                Text(user.email!),
                Text(user.gender!),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (BuildContext context) =>
                                    EditUserPage(user: user),
                          ),
                        );
                      },
                      child: Text("Edit"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _deleteUser(user.id.toString());
                      },
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _deleteUser(String id) async {
    String msg = "";
    try {
      final Map<String, dynamic> response = await UserApi.deleteUser(id);
      msg = response["message"];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: Duration(seconds: 2)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Failed to delete user: $e")));
    } finally {
      setState(() {}); // Refresh the UI after deletion
    }
  }
}
