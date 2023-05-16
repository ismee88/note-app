import 'package:flutter/material.dart';
import 'package:notes_app/model/note.model.dart';
import 'package:notes_app/repository/note.repo.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  final _formKey = GlobalKey<FormState>();

  String selectedMatiere = '';
  final noteController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(value: 'Java', child: Text("Java")),
                  DropdownMenuItem(value: 'PHP', child: Text("PHP")),
                  DropdownMenuItem(value: 'DevOps', child: Text("DevOps")),
                  DropdownMenuItem(value: 'CSharp', child: Text("Csharp")),
                  DropdownMenuItem(value: 'Oracle', child: Text("Oracle")),
                  DropdownMenuItem(value: 'Anglais', child: Text("Anglais")),
                  DropdownMenuItem(value: 'Python', child: Text("Python"))
                ],
                decoration: InputDecoration(
                  labelText: 'Matiere',
                  hintText: 'Choisir matiere',
                  border: OutlineInputBorder()
                ),
                //value: selectedMatiere,
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Veuillez remplir le champ !!";
                  }
                  return null;
                },
                onChanged: (value){
                  setState(() {
                    selectedMatiere = value!;
                  });
                }
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Note',
                  hintText: 'Saisir la note',
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Veuillez remplir le champ !!";
                  }
                  return null;
                },
                controller: noteController,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    final note1 = noteController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi en cours..."))
                    );
                    FocusScope.of(context).requestFocus(FocusNode());

                    print("Ajout de la matiere $selectedMatiere avec la note $note1");
                    
                    final note = Note(matiere: selectedMatiere, note: int.parse(noteController.text));
                    addNote(note);
                    noteController.text = '';
                    selectedMatiere = '';

                  }
                }, 
                child: Text("Envoyer")
              )
            )
          ],
        )
      )
    );
  }
}