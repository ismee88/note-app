import 'package:cloud_firestore/cloud_firestore.dart';
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

  //String selectedMatiere = '';
  String selectedMatiere = "0";
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('matiere').snapshots(),
                builder: (context, snapshot){
                  List<DropdownMenuItem> matiereItems = [];
                  if(!snapshot.hasData)
                  {
                    const CircularProgressIndicator();
                  }
                  else
                  {
                    final matieres = snapshot.data?.docs.reversed.toList();
                    matiereItems.add(const DropdownMenuItem(
                      value: "0",
                      child: Text('Choisir matiere'),
                    ),);
                    for (var matiere in matieres!){
                      matiereItems.add(DropdownMenuItem(
                        value: matiere['nom'],
                        child: Text(matiere['nom'],
                        )
                      ),
                      );
                    } 
                  }
                  return DropdownButtonFormField(
                    items: matiereItems, 
                    decoration: const InputDecoration(
                      labelText: 'Matiere',
                      hintText: 'Choisir matiere',
                      border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value == "0" || value.isEmpty){
                        return "Veuillez remplir le champ !!";
                      }
                      return null;
                    },
                    onChanged: (matiereValue){
                      setState(() {
                        selectedMatiere = matiereValue;
                      });
                      print(matiereValue);
                    },
                    value: selectedMatiere,
                    isExpanded: false,
                  );
                }),
              /*child: DropdownButtonFormField(
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
              ),*/
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
                  int? number = int.tryParse(value);
                  if (number == null || number > 20 || number < 0) {
                    return 'Veuillez entrer un nombre entre 0 et 20';
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