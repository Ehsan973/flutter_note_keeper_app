import 'package:flutter/material.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen(this.appBarTitle, {super.key});
  final String appBarTitle;
  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static final _priorities = ['High', 'Low'];

  String? _selectedUserValue = 'Low';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
                value: _selectedUserValue,
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    _selectedUserValue = valueSelectedByUser;
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
                onChanged: (value) {},
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
                onChanged: (value) {},
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
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Delete button clicked!');
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
}
