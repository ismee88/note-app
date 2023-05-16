import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/repository/note.repo.dart';

import '../model/note.model.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.greettings = ""});

  final String greettings;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Stream<QuerySnapshot> noteStudents =
      FirebaseFirestore.instance.collection('notes').snapshots();

  // For Deleting User
  CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  Future<void> deleteNote(id) {
    // print("note Deleted $id");
    return notes
        .doc(id)
        .delete()
        .then((value) => print('Note Deleted'))
        .catchError((error) => print('Failed to Delete note: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: noteStudents,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List notesdocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            notesdocs.add(a);
            a['id'] = document.id;
          }).toList();

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(140),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              'Matiere',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              'Note',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              'Action',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var i = 0; i < notesdocs.length; i++) ...[
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                              child: Text(notesdocs[i]['matiere'],
                                  style: TextStyle(fontSize: 18.0))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(notesdocs[i]['note'].toString(),
                                  style: TextStyle(fontSize: 18.0))),
                        ),
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              IconButton(
                                onPressed: () => {
                                  showDialog(
                                    context: context, 
                                    builder: (context)=>AlertDialog(
                                      title: Text('Voulez vous vraiment supprimer ${notesdocs[i]['matiere']} ?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            deleteNote(notesdocs[i]['id']);
                                            Navigator.pop(context, 'Oui');
                                          },
                                          child: Text('Oui'),
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(context, 'Annuler');
                                          },
                                          child: Text('Non'),
                                        )
                                      ],
                                    )
                                  ),
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        });
  } 
}
