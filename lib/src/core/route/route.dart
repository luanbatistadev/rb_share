import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rb_share/src/app.dart';
import 'package:rb_share/src/core/utils/constants.dart';
import 'package:rb_share/src/modules/receive/presenter/send/uploading_widget.dart';
import 'package:rb_share/src/modules/receive/presenter/send_widget.dart';
import 'package:rb_share/src/modules/receive/presenter/server/server_widget.dart';
import 'package:rb_share/src/modules/share/presenter/share_page.dart';
import 'package:rb_share/src/modules/share/submodules/scan_qr_code/presenter/scan_qr_widget.dart';

final GoRouter router = GoRouter(
  navigatorKey: _navigatorKey,
  errorBuilder: (BuildContext context, GoRouterState state) => ErrorWidget(state.error!),
  routes: <GoRoute>[
    GoRoute(
      path: mRootPath,
      redirect: (context, state) {
        return '/$mNavigationPath';
      },
    ),
    GoRoute(
      name: mNavigationPath,
      path: '/$mNavigationPath',
      builder: (context, state) => const RBShareApp(
        initialTab: HomeTab.receive,
      ),
    ),
    GoRoute(
      name: mServerPath,
      path: '/$mServerPath',
      builder: (context, state) => const ServerWidget(),
    ),
    GoRoute(
      name: mSharePath,
      path: '/$mSharePath',
      builder: (context, state) => const SharePage(),
      routes: [
        GoRoute(
          name: mSendPath,
          path: mSendPath,
          builder: (BuildContext context, GoRouterState state) => const SendWidget(),
          routes: [
            GoRoute(
              name: mUploadingPath,
              path: mUploadingPath,
              builder: (context, state) => const UploadingWidget(),
            )
          ],
        ),
        // GoRoute(
        //   name: mReceivePath,
        //   path: mReceivePath,
        //   builder: (BuildContext context, GoRouterState state) => const ReceiveWidget(),
        // ),
        GoRoute(
          name: mScanningPath,
          path: mScanningPath,
          builder: (BuildContext context, GoRouterState state) => const ScanQRWidget(),
        ),
      ],
    ),
  ],
);

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
