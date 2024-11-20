import 'package:flutter/material.dart';
import 'package:noteappwrite/appwrite_model.dart';
import 'package:noteappwrite/appwrite_service.dart';

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  late AppwriteService _appwriteService;
  late List<Note> _notes;

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteService.getTasks();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks:$e');
    }
  }

  Future<void> _addNote() async {
    final title = titleController.text;
    final subtitle = subtitleController.text;
    final category = categoryController.text;
    final date = dateController.text;
    if (title.isNotEmpty &&
        subtitle.isNotEmpty &&
        category.isNotEmpty &&
        date.isNotEmpty) {
      try {
        await _appwriteService.addNote(title, subtitle, category, date);
        titleController.clear();
        subtitleController.clear();
        categoryController.clear();
        dateController.clear();
        _loadNotes();
      } catch (e) {
        print("Error adding task:$e");
      }
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _appwriteService.deleteTask(taskId);
      _loadNotes();
    } catch (e) {
      print("Error  deleting task:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Title")),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: subtitleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Subtitle")),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Category")),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("date")),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: _addNote, child: Text("Add Notes")),
            Expanded(
                child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final notes = _notes[index];
                      return ListTile(
                        title: Text(
                          notes.title,
                        ),
                        subtitle: Column(
                          children: [
                            Text(notes.subtitle),
                            Text(notes.category),
                            Text(notes.date),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(notes.id),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
