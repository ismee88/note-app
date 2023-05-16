class Note{


  
  String id;
  String matiere;
  int note;

   Note({this.id='', required this.matiere, required this.note});

  //methode convertire objet en collection
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'matiere':matiere,
      'note':note
    };
  }

  //methode convertire collection
  factory Note.fromJson(Map<String, dynamic> json){
    return Note(id: json['id'], matiere: json['matiere'], note: json['note']);
  }
  





  
  
  

}
