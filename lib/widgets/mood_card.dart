import 'package:flutter/material.dart';
import 'package:mental_health_tracker/models/moodentry_form.dart';
import 'package:mental_health_tracker/screens/list_moodentry.dart';
import 'package:mental_health_tracker/screens/login.dart'; 
import 'package:mental_health_tracker/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart'; // Tambahkan ini untuk provider
import 'package:mental_health_tracker/screens/login.dart'; // Sesuaikan path jika diperlukan

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {  // Ubah menjadi async untuk mendukung operasi asinkron
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("Kamu telah menekan tombol ${item.name}!"),
            ));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Tambah Mood") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodEntryFormPage(),
              ),
            );
          } else if (item.name == "Lihat Mood") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodEntryPage(),
              ),
            );
          }
          // Tambahkan else if untuk Logout
          else if (item.name == "Logout") {
            final response = await request.logout(
              "http://[APP_URL_KAMU]/auth/logout/" // Ganti dengan URL yang benar
            );
            String message = response["message"];
            
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), // Sesuaikan dengan halaman login
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// List of items for the grid
final List<ItemHomepage> items = [
  ItemHomepage("Lihat Mood", Icons.mood),
  ItemHomepage("Tambah Mood", Icons.add),
  ItemHomepage("Logout", Icons.logout),
];
