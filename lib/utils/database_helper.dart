import 'dart:io';

import 'package:note_keeper_app/data/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; //Singleton DatabaseHelper
  static Database? _database; //Singleton DatabaseHelper

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';
    print(path);

    // Open/create the database at a given path
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  //Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    // Raw query
    // var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');

    // Query with helper function
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    Database db = await database;
    // var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    var result =
        await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  //Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    var result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    List<Note> noteList = noteMapList
        .map<Note>((mapObject) => Note.fromMapObject(mapObject))
        .toList();

    return noteList;
  }
}
