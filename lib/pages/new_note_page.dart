import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/note_model.dart';

class NewNotePage extends StatefulWidget {
  final NoteModel? note;

  const NewNotePage({super.key, this.note});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  TextEditingController bodyController = TextEditingController();
  FocusNode bodyFocus = FocusNode();

  @override
  void initState() {
    titleController.text = widget.note?.title ?? "";
    bodyController.text = widget.note?.body ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EEE2),
      appBar: AppBar(
        backgroundColor: Color(0xffF8EEE2),
        surfaceTintColor: Color(0xffF8EEE2),
        title: Text(
          widget.note != null ? "Edit Note" : "New Note",
          style: GoogleFonts.nunito(
            color: Color(0xff403B36),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () async {
              DateTime? oldTime = widget.note?.time;
              String title = titleController.text.trim();
              String body = bodyController.text.trim();
              if (title.isEmpty || body.isEmpty) return;
              NoteModel note = NoteModel(
                title: title,
                body: body,
                time: oldTime ?? DateTime.now(),
              );
              await addNewNote(note);
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: GoogleFonts.montserrat(
                color: Color(0xff403B36),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: titleController,
              focusNode: titleFocus,
              cursorColor: Color(0xff403B36),
              onTapOutside: (_) {
                titleFocus.unfocus();
                bodyFocus.unfocus();
              },
              style: GoogleFonts.nunito(
                color: Color(0xff403B36),
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              maxLength: 30,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Title...",
                hintStyle: TextStyle(
                  color: Color(0xff595550),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                focusNode: bodyFocus,
                cursorColor: Color(0xff403B36),
                onTapOutside: (_) {
                  titleFocus.unfocus();
                  bodyFocus.unfocus();
                },
                textInputAction: TextInputAction.done,
                style: GoogleFonts.nunito(
                  color: Color(0xff403B36),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: null,
                expands: true,
                autocorrect: false,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  helper: SizedBox.shrink(),
                  counter: SizedBox.shrink(),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Body...",
                  hintStyle: TextStyle(
                    color: Color(0xff595550),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
