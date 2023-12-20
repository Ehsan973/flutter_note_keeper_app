import 'package:flutter/material.dart';

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
        onPressed: () {},
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
            onTap: () {},
          ),
        );
      },
    );
  }
}
