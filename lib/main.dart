import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isBulletList = false;
  int numberedListCount = -1;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  String insertStringAtIndex(
      String originalString, String stringToInsert, int index) {
    return originalString.substring(0, index) +
        stringToInsert +
        originalString.substring(index);
  }

  void _convertToBulletList() {
    String text = _textController.text;
    int lineBreakIndex = text.length - 1;
    while (lineBreakIndex >= 0 && text[lineBreakIndex] != '\n') {
      lineBreakIndex--;
    }
    _textController.text = insertStringAtIndex(text, '• ', lineBreakIndex + 1);
  }

  void _convertToNumberedList() {
    String text = _textController.text;
    int lineBreakIndex = text.length - 1;
    while (lineBreakIndex >= 0 && text[lineBreakIndex] != '\n') {
      lineBreakIndex--;
    }
    _textController.text = insertStringAtIndex(
        text, '${numberedListCount++}. ', lineBreakIndex + 1);
  }

  bool _isNumeric(String str) {
    try {
      double.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Editor'),
      ),
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(hintText: 'Title'),
          ),
          Expanded(
            child: ListView(
              children: [
                TextField(
                  onChanged: (value) {
                    //When we are deleting characters and then find a bullet
                    if (value.length > 2 &&
                        value[value.length - 1] == '•' &&
                        value[value.length - 2] == '\n') {
                      _textController.text =
                          value.substring(0, value.length - 2);
                    }
                    //When we are deleting numbered list items
                    if (value.length > 1 && value[value.length - 1] == '.') {
                      int index = value.length - 2;
                      while (index >= 0 && _isNumeric(value[index])) {
                        index--;
                      }
                      if (index == -1) {
                        _textController.text = '';
                      }
                      if (value[index] == '\n') {
                        _textController.text = value.substring(0, index);
                      }
                    }
                    //When we enter a new bullet or number gets created
                    if (value[value.length - 1] == '\n') {
                      if (isBulletList) {
                        _textController.text = '$value• ';
                      }
                      if (numberedListCount != -1) {
                        _textController.text = '$value${numberedListCount++}. ';
                      }
                    }
                    final textLength = _textController.text.length;
                    _textController.selection = TextSelection(
                      baseOffset: textLength,
                      extentOffset: textLength,
                    );
                  },
                  controller: _textController,
                  focusNode: _textFocus,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Write more here...',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.format_list_bulleted,
              ),
              onPressed: () {
                setState(() {
                  isBulletList = !isBulletList;
                  if (isBulletList) {
                    _convertToBulletList();
                  }
                  _textFocus.requestFocus();
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.format_list_numbered,
              ),
              onPressed: () {
                setState(() {
                  if (numberedListCount == -1) {
                    numberedListCount = 1;
                  } else {
                    numberedListCount = -1;
                  }
                  if (numberedListCount == 1) {
                    _convertToNumberedList();
                  }
                  _textFocus.requestFocus();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
