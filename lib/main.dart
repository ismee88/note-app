import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'interfaces/home.dart';
import 'interfaces/note.dart';

import 'interfaces/home2.dart';
import 'interfaces/note2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppNote());
}

class AppNote extends StatefulWidget {
  const AppNote({super.key});

  @override
  State<AppNote> createState() => _AppNoteState();
}

class _AppNoteState extends State<AppNote> {

  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: [
            Text("Acceuil"),
            Text("Ajout Note")
          ][_currentIndex],
        ),
        body: const[
          Home(),
          NotesScreen()
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajouter'
            )
          ],
        ),
      ),
    );
  }
}