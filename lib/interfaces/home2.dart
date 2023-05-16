import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home2 extends StatefulWidget {
  const Home2({super.key, this.greettings = ""});

  final String greettings;
  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {

  List notedata=[];

  Future <void> delrecord(String id) async {
    try{
      String uri = "http://10.0.2.2/NoteAPI/delete_data.php";

      var res = await http.post(Uri.parse(uri), body: {
        "id": id
      });

      var response = jsonDecode(res.body);

      if(response["success"]=="true"){
        print("record deleted");
        getrecord();
      }else{
        print("some issue");
      }
    }catch(e){
      print(e);
    }
  }

  Future <void> getrecord() async {
    String uri = "http://10.0.2.2/NoteAPI/view_data.php";
    try{
      var response = await http.get(Uri.parse(uri));
      
      setState(() {
        notedata = jsonDecode(response.body);
      });

    }catch(e){
      print(e);
    }
  }

  @override
  void initState(){
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notedata.length,
        itemBuilder: (context, index){
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(notedata[index]["matiere"]),
              subtitle: Text(notedata[index]["note"].toString()),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  delrecord(notedata[index]["id"]);
                },
              ),
            ),
          );
        }
      ),
    );
  } 
}
