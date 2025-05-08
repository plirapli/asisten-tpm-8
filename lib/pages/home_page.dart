import 'package:asisten_tpm_8/models/user_model.dart';
import 'package:asisten_tpm_8/pages/create_user_page.dart';
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
      body: Padding(padding: EdgeInsets.all(20), child: _userContainer()),
    );
  }

  Widget _userContainer() {
    /*
      FutureBuilder adalah widget yang membantu menangani proses asynchronous
      Proses async adalah proses yang membutuhkan waktu. (ex: mengambil data dari API)

      FutureBuilder itu butuh 2 properti, yaitu future dan builder.
      Properti future adalah proses async yg akan dilakukan.
      Properti builder itu tampilan yg akan ditampilkan berdasarkan proses future tadi.
      
      Properti builder itu pada umumnya ada 2 status, yaitu hasError dan hasData.
      Status hasError digunakan untuk mengecek apakah terjadi kesalahan (misal: jaringan error).
      Status hasData digunakan untuk mengecek apakah data sudah siap.
    */
    return FutureBuilder(
      future: UserApi.getUsers(),
      builder: (context, snapshot) {
        // Jika error (gagal memanggil API), maka tampilkan teks error
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        // Jika berhasil memanggil API
        else if (snapshot.hasData) {
          /*
            Baris 1:
            Untuk mengambil response dari API, kita bisa mengakses "snapshot.data"
            Nah, snapshot.data tadi itu bentuknya masih berupa Map<String, dynamic>.

            Untuk memudahkan pengolahan data, 
            kita perlu mengonversi data JSON tersebut ke dalam 
            model Dart (UsersModel) untuk memudahkan pengolahan data.
            Setelah itu, hasil konversinya disimpan ke dalam variabel bernama "response".

            Baris 2:
            Setelah dikonveri, tampilkan data tadi di widget bernama "_userlist()"
            dengan mengirimkan data tadi sebagai parameternya.

            Kenapa yg dikirim "response.data" bukan "response" aja?
            Karena kalau kita lihat di dokumentasi API, bentuk response-nya itu kaya gini:
            {
              "status": ...
              "message": ...
              "data": [
                {
                  "id": 1,
                  "name": "rafli",
                  "email": "rafli@gmail.com",
                  "gender": "Male",
                  "createdAt": "2025-04-29T13:17:17.000Z",
                  "updatedAt": "2025-04-29T13:17:17.000Z"
                },
                ...
              ]
            }

            Nah, kita itu cuman mau ngambil properti "data" doang, 
            kita gamau ngambil properti "status" dan "message",
            makanya yg kita kirim ke Widget _userlist itu response.data
          */
          UserModel response = UserModel.fromJson(snapshot.data!);
          return _userList(context, response.data!);
        }

        // Loading screen
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _userList(BuildContext context, List<User> users) {
    return ListView(
      children: [
        // Tombol create user
        ElevatedButton(
          onPressed: () {
            // Pindah ke halaman CreateUserPage() (create_user_page.dart)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const CreateUserPage(),
              ),
            );
          },
          child: Text("Create New User"),
        ),

        // Tampilkan tiap-tiap user dengan melakukan perulangan pada variabel "users".
        // Simpan data tiap user ke dalam variabel "user" (gapake s)
        for (var user in users)
          Container(
            // Untuk keperluan tampilan doang (opsional)
            margin: EdgeInsets.only(top: 12), // <- Ngasih margin
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ), // <- Ngasih Padding
            color: Colors.green.shade100, // <- Ngasih warna background ijo
            // Nampilin datanya dalam bentuk layout kolom (ke bawah)
            child: Column(
              // Cross Axis Alignment "Stretch" berfungsi supaya teks menjadi rata kiri
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tampilkan nama, email, gender dalam bentuk teks
                Text(user.name!),
                Text(user.email!),
                Text(user.gender!),
              ],
            ),
          ),
      ],
    );
  }
}
