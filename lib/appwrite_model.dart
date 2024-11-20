import 'package:appwrite/models.dart';

class Note {
  final String id;
  final String title;
  final  String subtitle;
  final String category;
  final String date;


  Note({required this.id,required this.title, required this.subtitle,required this.category,required this.date});

  factory Note.fromDocument(Document doc) {
    return Note(id: doc.$id,title:doc.data["title"],subtitle: doc.data['subtitle'], category: doc.data['category'],date:doc.data['date']);
  }
}
