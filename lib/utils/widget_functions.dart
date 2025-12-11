import 'package:flutter/material.dart';

/// Show a simple dialog with a single text input and OK / Close actions.
///
/// The [onSubmit] callback is invoked with the non-empty text value when
/// the positive button is pressed. Empty input is ignored.
void showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  String posBtnTxt = 'OK',
  String negBtnTxt = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final TextEditingController controller = TextEditingController();

  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: 'Enter $title'),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(negBtnTxt),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isEmpty) {
                return;
              }
              onSubmit(controller.text);
              Navigator.pop(dialogContext);
            },
            child: Text(posBtnTxt),
          ),
        ],
      );
    },
  );
}

/// Show a short [SnackBar] with the given message.
///
/// This is a convenience helper that uses [ScaffoldMessenger] so it works
/// even when there is no direct [ScaffoldState] access.
void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
