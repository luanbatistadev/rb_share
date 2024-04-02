import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/init.dart';
import 'package:rb_share/pages/home_page.dart';
import 'package:rb_share/provider/local_ip_provider.dart';
import 'package:rb_share/widget/watcher/life_cycle_watcher.dart';
import 'package:rb_share/widget/watcher/shortcut_watcher.dart';
import 'package:rb_share/widget/watcher/tray_watcher.dart';
import 'package:rb_share/widget/watcher/window_watcher.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

Future<void> main(List<String> args) async {
  final container = await preInit(args);

  runApp(
    RefenaScope.withContainer(
      container: container,
      child: TranslationProvider(
        child: const RBShareApp(),
      ),
    ),
  );
}

class RBShareApp extends StatelessWidget {
  const RBShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = context.ref;
    // final (themeMode, colorMode) =
    //     ref.watch(settingsProvider.select((settings) => (settings.theme, settings.colorMode)));
    // final dynamicColors = ref.watch(dynamicColorsProvider);
    return TrayWatcher(
      child: WindowWatcher(
        child: LifeCycleWatcher(
          onChangedState: (AppLifecycleState state) {
            if (state == AppLifecycleState.resumed) {
              ref.redux(localIpProvider).dispatch(InitLocalIpAction());
            }
          },
          child: ShortcutWatcher(
            child: MaterialApp(
              title: t.appName,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF440A64),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                fontFamily: GoogleFonts.poppins().fontFamily,
                textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
              ),
              // themeMode: colorMode == ColorMode.oled ? ThemeMode.dark : themeMode,
              navigatorKey: Routerino.navigatorKey,
              home: RouterinoHome(
                builder: () => const HomePage(
                  initialTab: HomeTab.receive,
                  appStart: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
