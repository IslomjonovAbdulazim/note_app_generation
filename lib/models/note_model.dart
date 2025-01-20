import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NoteModel {
  late String title;
  late String body;
  late DateTime time;

  NoteModel({
    required this.title,
    required this.body,
    required this.time,
  });

  NoteModel.fromJson(Map json) {
    title = json["title"];
    body = json["body"];
    time = DateTime.parse(json["time"]);
  }

  Map toJson() {
    Map json = {};
    json["title"] = title;
    json["body"] = body;
    json["time"] = time.toIso8601String();
    return json;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

Future<void> addNewNote(NoteModel note) async {
  List<NoteModel> notes = await getNotes();
  notes.removeWhere((obj) => obj.time == note.time);
  notes.add(note);
  await saveNotes(notes);
}

Future<void> deleteNote(NoteModel note) async {
  List<NoteModel> notes = await getNotes();
  notes.removeWhere((obj) => obj.time == note.time);
  await saveNotes(notes);
}

Future<void> saveNotes(List<NoteModel> notes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonList =
      notes.map((note) => json.encode(note.toJson())).toList();

  await prefs.setStringList('notes', jsonList);
}

Future<List<NoteModel>> getNotes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? jsonList = prefs.getStringList('notes');

  if (jsonList != null) {
    List<NoteModel> notes = jsonList
        .map((jsonStr) => NoteModel.fromJson(json.decode(jsonStr)))
        .toList();
    notes.sort((a, b) => b.time.compareTo(a.time));
    return notes;
  } else {
    return [];
  }
}
