import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/note_model.dart';
import 'new_note_page.dart';

class NoteHomePage extends StatefulWidget {
  const NoteHomePage({super.key});

  @override
  State<NoteHomePage> createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    notes = await getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EEE2),
      appBar: AppBar(
        backgroundColor: Color(0xffF8EEE2),
        surfaceTintColor: Color(0xffF8EEE2),
        title: Text(
          "All Notes",
          style: GoogleFonts.nunito(
            color: Color(0xff403B36),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return NewNotePage();
                }),
              );
              await loadData();
            },
            icon: Icon(
              Icons.add,
              color: Color(0xff403B36),
              size: 30,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: notes.isEmpty
          ? SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset("assets/note.png"),
                      SizedBox(height: 30),
                      Text(
                        "Create Your First Note",
                        style: GoogleFonts.nunito(
                          color: Color(0xff403B36),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Add a note about anything (your thoughts on climate change, or your history essay) and share it with the world.",
                        style: GoogleFonts.nunito(
                          color: Color(0xff595550),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffD9614C),
                          fixedSize: Size.fromHeight(55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return NewNotePage();
                            }),
                          );
                          await loadData();
                        },
                        child: Center(
                          child: Text(
                            "Create A Note",
                            style: GoogleFonts.nunito(
                              color: Color(0xffFFFBFA),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
          )
          : ListView.builder(
              itemCount: notes.length,
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemBuilder: (_, int index) {
                NoteModel note = notes[index];
                return Card(
                  color: Color(0xffD9614C),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewNotePage(note: note),
                        ),
                      );
                      await loadData();
                    },
                    title: Text(
                      note.title,
                      style: GoogleFonts.nunito(
                        color: Color(0xffffffff),
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.body,
                          style: GoogleFonts.nunito(
                            color: Color(0xffffffff),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                          maxLines: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat.MMMMd().format(note.time),
                              style: GoogleFonts.quicksand(
                                color: Color(0xffFFFFFF),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              " at ",
                              style: GoogleFonts.quicksand(
                                color: Color(0xffFFFFFF),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat.Hm().format(note.time),
                              style: GoogleFonts.quicksand(
                                color: Color(0xffFFFFFF),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 6,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await deleteNote(note);
                        await loadData();
                      },
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: Color(0xffFFFFFF),
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
