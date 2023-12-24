import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:note_keeper_app/data/models/note.dart';
import 'package:note_keeper_app/screens/note_detail_screen.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note>? noteList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    noteList ??= <Note>[];
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: _getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetailScreen(context, Note('title', 'date', 2), 'Add Note');
        },
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
        tooltip: 'Add Note',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Delete
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // Return the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  Widget _getNoteListView() {
    // TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: noteList!.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList![index].priority),
              child: const Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(noteList![index].title),
            subtitle: Text(noteList![index].date),
            trailing: GestureDetector(
              onTap: () {
                _delete(context, noteList![index]);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              navigateToDetailScreen(context, noteList![index], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetailScreen(BuildContext context, Note note, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(title, note: note),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    final Database db = await databaseHelper.initializeDatabase();
    List<Note> noteList = await databaseHelper.getNoteList();
    setState(() {
      count = noteList.length;
      this.noteList = noteList;
    });
  }
}
