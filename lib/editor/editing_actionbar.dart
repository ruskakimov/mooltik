import 'package:flutter/material.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';

class EditingActionbar extends StatelessWidget {
  const EditingActionbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppIconButton(
          icon: FontAwesomeIcons.arrowLeft,
          onTap: () async {
            final project = context.read<Project>();
            await project.save();
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              project.close();
            });
          },
        ),
        Spacer(),
        AppIconButton(
          icon: FontAwesomeIcons.fileDownload,
          onTap: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) => Dialog(
              shape: CircleBorder(),
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: CircularProgressIndicator(
                        value: 0,
                        strokeWidth: 20,
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).colorScheme.primary,
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: SizedBox(
                        width: 230,
                        height: 230,
                        child: Center(
                          child: Text(
                            'Export video',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
