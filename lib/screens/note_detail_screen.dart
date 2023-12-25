import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_app/data/models/note.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen(this.appBarTitle, {super.key, required this.note});
  final String appBarTitle;
  final Note note;
  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static final _priorities = ['High', 'Low'];

  Note? note;
  DatabaseHelper databaseHelper = DatabaseHelper();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    note = widget.note;
    titleController.text = note!.title;
    descriptionController.text = note!.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            moveToLastScreen();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                value: getPriorityAsString(note!.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    updatePriorityAsInt(valueSelectedByUser!);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: titleController,
                style: const TextStyle(fontSize: 12),
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                controller: descriptionController,
                style: const TextStyle(fontSize: 12),
                onChanged: (value) {
                  updateDescription();
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Save button clicked!');
                        _save();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Delete button clicked!');
                        _delete();
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.of(context).pop(true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note!.priority = 1;
        break;
      case 'Low':
        note!.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0];
      case 2:
        return _priorities[1];
      default:
        return _priorities[0];
    }
  }

  void updateTitle() {
    note!.title = titleController.text;
  }

  void updateDescription() {
    note!.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note!.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note!.id != null) {
      result = await databaseHelper.updateNote(note!);
    } else {
      result = await databaseHelper.insertNote(note!);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note!.id == null) {
      _showAlertDialog('Status', 'No Note was deleted!');
      return;
    }

    int result = await databaseHelper.deleteNote(note!.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note deleted successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while deleting note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
