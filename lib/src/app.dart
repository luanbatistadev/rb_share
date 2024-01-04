import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rb_share/src/core/utils/constants.dart';
import 'package:rb_share/src/modules/share/presenter/share_page.dart';

class RBShareApp extends StatelessWidget {
  const RBShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SharePage()));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.share),
                  SizedBox(
                    width: 4,
                  ),
                  Text('Share'),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(mServerPath);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded),
                  SizedBox(
                    width: 4,
                  ),
                  Text('Receive'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
