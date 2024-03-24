import 'package:flutter/material.dart';
import 'package:rb_share/src/modules/receive/presenter/receive_tab.dart';
import 'package:rb_share/src/modules/send/send_tab.dart';

class RBShareApp extends StatefulWidget {
  final HomeTab initialTab;

  const RBShareApp({super.key, required this.initialTab});

  @override
  State<RBShareApp> createState() => _RBShareAppState();
}

enum HomeTab {
  receive(Icons.wifi),
  send(Icons.send),
  settings(Icons.settings);

  const HomeTab(this.icon);

  final IconData icon;

  String get label {
    switch (this) {
      case HomeTab.receive:
        return 'Receber';
      case HomeTab.send:
        return 'Enviar';
      case HomeTab.settings:
        return 'Configurações';
    }
  }
}



class _RBShareAppState extends State<RBShareApp> {
  HomeTab _currentTab = HomeTab.receive;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialTab.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentTab.index,
          onDestinationSelected: _goToPage,
          destinations: HomeTab.values.map((tab) {
            return NavigationDestination(icon: Icon(tab.icon), label: tab.label);
          }).toList(),
        ),
        body: Row(
          children: [
            Expanded(
              child: SafeArea(
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ReceiveTab(),
                        const SendTab(),
                        ReceiveTab(),
                        // SendTab(),
                        // SettingsTab(),
                      ],
                    ),
                    // if (_dragAndDropIndicator)
                    //   Container(
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).scaffoldBackgroundColor,
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Icon(Icons.file_download, size: 128),
                    //         const SizedBox(height: 30),
                    //         Text(t.sendTab.placeItems, style: Theme.of(context).textTheme.titleLarge),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        )

        //  Center(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       TextButton(
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => const SharePage()));
        //         },
        //         child: const Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Icon(Icons.share),
        //             SizedBox(
        //               width: 4,
        //             ),
        //             Text('Enviar'),
        //           ],
        //         ),
        //       ),
        //       const SizedBox(
        //         width: 12,
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           context.pushNamed(mServerPath);
        //         },
        //         child: const Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Icon(Icons.download_rounded),
        //             SizedBox(
        //               width: 4,
        //             ),
        //             Text('Receber'),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }

  void _goToPage(int index) {
    final tab = HomeTab.values[index];
    setState(() {
      _currentTab = tab;
      _pageController.animateToPage(
        _currentTab.index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }
}
