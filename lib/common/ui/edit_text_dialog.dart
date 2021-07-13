import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/dialog_done_button.dart';

class EditTextDialog extends StatefulWidget {
  const EditTextDialog({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onSubmit,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
  }) : super(key: key);

  final String title;
  final String initialValue;
  final ValueChanged<String> onSubmit;

  final int maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;

  @override
  _EditTextDialogState createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController controller;

  bool _allowSubmit = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.initialValue,
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: widget.initialValue.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DialogDoneButton(
            onPressed: _allowSubmit
                ? () {
                    widget.onSubmit(controller.text);
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              setState(() {
                _allowSubmit = _formKey.currentState!.validate();
              });
            },
            child: TextFormField(
              controller: controller,
              autofocus: true,
              minLines: 1,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              validator: widget.validator,
            ),
          ),
        ),
      ),
    );
  }
}
