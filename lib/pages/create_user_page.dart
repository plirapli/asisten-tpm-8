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
  /* 
    Controller dipake buat mengelola input teks dari TextField.
    Di sini kita bikin controller buat input name sama email.
    Buat input gender, hasilnya cukup kita simpan ke dalam string biasa karena kita make radio button
  */
  final name = TextEditingController();
  final email = TextEditingController();
  String? gender;

  // Fungsi untuk membuat user ketika tombol "Create User" diklik
  Future<void> _createUser(BuildContext context) async {
    try {
      /*
        Karena kita mau membuat user, maka kita juga perlu datanya.
        Disini kita mengambil data nama, email, & gender yang dah diisi pada form,
        Terus datanya itu disimpan ke dalam variabel "newUser" dengan tipe data User.
      */
      User newUser = User(
        name: name.text.trim(),
        email: email.text.trim(),
        gender: gender,
      );

      /*
        Lakukan pemanggilan API create, setelah itu
        simpan ke dalam variabel bernama "response"
      */
      final response = await UserApi.createUser(newUser);

      /*
        Jika response status "Success", 
        maka tampilkan snackbar yg bertuliskan "Berhasil menambah user baru"
      */
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Berhasil menambah user baru")));

        // Pindah ke halaman sebelumnya
        Navigator.pop(context);

        // Untuk merefresh tampilan (menampilkan user baru ke dalam daftar)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        // Jika response status "Error", maka kode akan dilempar ke bagian catch
        throw Exception(response["message"]);
      }
    } catch (error) {
      /*
        Jika user gagal menghapus, 
        maka tampilkan snackbar dengan tulisan "Gagal: error-nya apa"
      */
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create User")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Buat input nama user
            TextField(
              /*
                Ngasi tau kalau ini input buat name, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "name" yg udah kita bikin di atas
              */
              controller: name,
              decoration: const InputDecoration(
                labelText: "Name", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            // Buat input email user
            TextField(
              /*
                Ngasi tau kalau ini input buat email, jadi segala hal yg kita ketikan 
                bakalan disimpan ke dalam variabel "email" yg udah kita bikin di atas
              */
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email", // <- Ngasi label
                border: OutlineInputBorder(), // <- Ngasi border di form-nya
              ),
            ),
            const SizedBox(height: 16), // <- Ngasi jarak antar widget
            // Buat input gender (pake radio button)
            Text("Gender"),
            Row(
              children: [
                // Radio button buat male
                Radio(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (event) {
                    // Kalau male dipilih,
                    // maka variabel "gender" akan memiliki nilai "Male"
                    setState(() {
                      gender = event;
                    });
                  },
                ),
                Text("Male"),
                // Radio button buat female
                Radio(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (event) {
                    // Kalau female dipilih,
                    // maka variabel "gender" akan memiliki nilai "Female"
                    setState(() {
                      gender = event;
                    });
                  },
                ),
                Text("Female"),
              ],
            ),
            // Tombol buat bikin user baru
            ElevatedButton(
              onPressed: () {
                // Jalankan fungsi _createUser() ketika tombol diklik
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
