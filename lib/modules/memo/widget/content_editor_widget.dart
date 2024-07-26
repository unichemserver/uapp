import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class ContentEditorWidget extends StatefulWidget {
  final Function(String) onTextChanged;

  const ContentEditorWidget({super.key, required this.onTextChanged});

  @override
  State<ContentEditorWidget> createState() => _ContentEditorWidgetState();
}

class _ContentEditorWidgetState extends State<ContentEditorWidget> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekanisme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Peringatan'),
                    content: const Text('Apakah anda ingin menyelesaikan mekanisme memo ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tutup'),
                      ),
                      TextButton(
                        onPressed: () {
                          final html = _controller.document.toDelta().toHtml();
                          widget.onTextChanged(html);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Simpan'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('id'),
                ),
              ),
            ),
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('id'),
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
