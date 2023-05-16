import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotesScreen2 extends StatefulWidget {
  const NotesScreen2({super.key});

  @override
  State<NotesScreen2> createState() => _NotesScreen2State();
}

class _NotesScreen2State extends State<NotesScreen2> {

  String selectedMatiere = '';
  final noteController = TextEditingController();

  //**********************Recuperer matiere***********************************************//
  String? _matiereSelected;
  String selMatiere = "";
  List matiereItemList = [];

  Future getAllMAtiere() async{
    var url = "http://10.0.2.2/NoteAPI/getMatiere.php";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      setState(() {
        matiereItemList = jsonData;
      });
    }
    print(matiereItemList);
  }

  @override
  void initState() {
    super.initState();
    getAllMAtiere();
    
  }
  //************************************************************************************ *//


  Future<void>insertrecord() async{
    if(selectedMatiere != "" || noteController.text != ""){
      try{
        String uri = "http://10.0.2.2/NoteAPI/insert_record.php";
        var res = await http.post(Uri.parse(uri), body: {
          "matiere": _matiereSelected,
          "note": noteController.text
        });
        var response = jsonDecode(res.body);
        if(response["success"]=="true"){
          print("Record Insert");
          _matiereSelected="";
          noteController.text="";
        }else{
          print("some issue");
        }
      }catch(e){
        print(e);
      }
    }else{
      print("Veuillez remplir les champs !!");
    }
  }

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
        
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField<String>(
                value: _matiereSelected,
                items: matiereItemList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['matiere'],
                    child: Text(item['matiere']),
                  );
                }).toList(),
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
                    _matiereSelected = value;
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
                  insertrecord();
                  FocusScope.of(context).requestFocus(FocusNode());
                }, 
                child: Text("Envoyer")
              )
            ),
          ],
        )
      )
    );
  }
}