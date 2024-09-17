import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reflect/main.dart';
import 'package:reflect/models/entry.dart';

class EntryPage extends ConsumerStatefulWidget {
  final Entry entry;
  const EntryPage({super.key, required this.entry});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  bool isEdited = false;
  late quill.QuillController quillController;
  late TextEditingController titleController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: widget.entry.title);
    if(widget.entry.content == null) quillController = quill.QuillController.basic();
    else {
      quillController = quill.QuillController(
        document: quill.Document.fromJson(widget.entry.content ?? []),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    titleController.addListener(() {
      if(!isEdited && titleController.text != widget.entry.title) {
        isEdited = true;
        setState(() {});
      }
      else if(isEdited && titleController.text == widget.entry.title) {
        isEdited = false;
        setState(() {});
      }
    });

    quillController.addListener(() {
      if(!isEdited && quillController.document.toDelta() != widget.entry.content) {
        isEdited = true;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeManagerProvider);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: themeData.brightness == Brightness.dark ? Alignment.topCenter : Alignment.bottomCenter,
            end: themeData.brightness == Brightness.dark ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [themeData.colorScheme.tertiary, themeData.colorScheme.onTertiary]
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            EntryAppbar(themeData: themeData),
            const SizedBox(height: 20),
            Text(DateFormat("dd MMM yyyy | hh:mm a").format(widget.entry.date), style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              clipBehavior: Clip.none,
              child: TextField(
                controller: titleController,
                style: themeData.textTheme.titleLarge?.copyWith(color: const Color(0xffFF9432)),
                decoration: InputDecoration(
                  hintText: "Title...",
                  hintStyle: themeData.textTheme.titleLarge?.copyWith(color: const Color(0xffFF9432).withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  
                ),
                maxLines: null,
              ),
            ),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: quillController,
                configurations: quill.QuillEditorConfigurations(
                  //checkBoxReadOnly: true
                  placeholder: "Start writing here...",
                  keyboardAppearance: themeData.brightness,
                  customStyles: quill.DefaultStyles(
                    paragraph: quill.DefaultTextBlockStyle(
                      themeData.textTheme.bodyMedium?.copyWith(fontSize: 16) ?? const TextStyle(),
                      quill.HorizontalSpacing(0, 0),
                      quill.VerticalSpacing(0, 0),
                      quill.VerticalSpacing.zero,
                      null
                    )
                  )
                    
                ),
              ),
            ),
            /*quill.QuillToolbar.simple(
              controller: quillController,
              configurations: const quill.QuillSimpleToolbarConfigurations(
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showColorButton: true,
                showBackgroundColorButton: false,
                showClearFormat: true,
                showHeaderStyle: false,
                showListNumbers: true,
                showListBullets: true,
                showCodeBlock: false,
                showQuote: true,
                showLink: false,
                showSubscript: false,
                showSuperscript: false,
                showAlignmentButtons: false,
                showClipboardCopy: false,
                showClipboardCut: false,
                showClipboardPaste: false,
                showDividers: false,
                showListCheck: false,
                showIndent: false,
                showFontFamily: false,
                showFontSize: false,
              )
            ),*/
            
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isEdited ? (){} : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                  backgroundColor: Color(0xffFF9432),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                ),
                child: Text('Save', style: themeData.textTheme.bodyMedium?.copyWith(color: themeData.colorScheme.onPrimary, fontWeight: FontWeight.w600),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryAppbar extends StatelessWidget {
  const EntryAppbar({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: themeData.colorScheme.onPrimary,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //const SizedBox(width: 10),
        
        IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.menu, color: themeData.colorScheme.onPrimary,),
        )
      ],
    );
  }
}