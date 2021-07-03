import 'package:flutter/material.dart';

class EditFileNameDialog extends StatefulWidget {
  const EditFileNameDialog({
    Key? key,
    required this.initialValue,
    required this.onSubmit,
  }) : super(key: key);

  final String initialValue;
  final ValueChanged<String> onSubmit;

  @override
  _EditFileNameDialogState createState() => _EditFileNameDialogState();
}

class _EditFileNameDialogState extends State<EditFileNameDialog> {
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
        title: Text('File name'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'Done',
            onPressed: _allowSubmit
                ? () {
                    widget.onSubmit(controller.text);
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
      body: Padding(
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
            maxLines: 1,
            maxLength: 30,
            validator: _fileNameValidator,
          ),
        ),
      ),
    );
  }

  String? _fileNameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }

    final reg = RegExp(r'^[A-Za-z0-9_-]+$');

    if (!reg.hasMatch(value)) {
      return 'Invalid character used';
    }

    return null;
  }
}
