import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/editable_field.dart';

class ExportImagesForm extends StatelessWidget {
  const ExportImagesForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditableField(
      label: 'Selected frames',
      text: '148',
      onTap: () {},
    );
  }
}
