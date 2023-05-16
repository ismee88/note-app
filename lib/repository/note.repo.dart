import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/model/note.model.dart';

//Ajout
Future addNote(Note note) async{
  final docNote = FirebaseFirestore.instance.collection("notes").doc();
  note.id = docNote.id;
  await docNote.set(note.toJson());
}

//Suppression
Future deleteNote(String id) async{
  final docNote = FirebaseFirestore.instance.collection("notes").doc(id);
  await docNote.delete();
}
