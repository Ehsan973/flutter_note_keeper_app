import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

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
          navigateToDetailScreen(context, 'Add Note');
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

  Widget _getNoteListView() {
    // TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: const Text('Dummy Title'),
            subtitle: const Text('Duddy Date'),
            trailing: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              navigateToDetailScreen(context, 'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetailScreen(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(title),
      ),
    );
  }
}
