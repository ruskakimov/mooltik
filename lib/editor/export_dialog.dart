import 'package:flutter/material.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                value: 0.72,
                backgroundColor: Colors.black12,
                strokeWidth: 20,
              ),
            ),
            // RaisedButton(
            //   color: Theme.of(context).colorScheme.primary,
            //   highlightColor: Colors.white12,
            //   splashColor: Colors.white,
            //   shape: CircleBorder(),
            //   onPressed: () {},
            //   child: SizedBox(
            //     width: 230,
            //     height: 230,
            //     child: Center(
            //       child: Text(
            //         'Export video',
            //         style: TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: Theme.of(context).colorScheme.onPrimary,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Text(
              '72%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
