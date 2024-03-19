import 'package:flutter/material.dart';
import 'package:rb_share/src/core/widgets/animations/initial_fade_transition.dart';
import 'package:rb_share/src/core/widgets/custom_icon_button.dart';
import 'package:rb_share/src/core/widgets/rb_share_logo.dart';
import 'package:rb_share/src/core/widgets/rotating_widget.dart';

class ReceiveTab extends StatelessWidget {
   ReceiveTab({super.key});


  final ValueNotifier<bool> showAdvanced = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InitialFadeTransition(
                              duration: Duration(milliseconds: 300),
                              delay: Duration(milliseconds: 200),
                              child: RotatingWidget(
                                duration: Duration(seconds: 15),
                                spinning: true,
                                child: RBShareLogo(withText: false),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('RB Share', style: TextStyle(fontSize: 48)),
                            ),
                            InitialFadeTransition(
                              duration: Duration(milliseconds: 300),
                              delay: Duration(milliseconds: 500),
                              child: Text(
                                'Limão adorável',
                                style: TextStyle(fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: showAdvanced,
          builder: (context, value, child) {
            return AnimatedCrossFade(
              crossFadeState: !value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
              firstChild: Container(),
              secondChild: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: IntrinsicColumnWidth(),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Text('Vulgo'),
                              SizedBox(width: 10),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: SelectableText('Vulgo'),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text('Vulgo'),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Vulgo'),
                                  ...['Vulgo', 'Vulgo'].map((ip) => SelectableText(ip)),
                                ],
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text('Vulgo'),
                              SizedBox(width: 10),
                              SelectableText('Vulgo'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (!vm.showAdvanced)
                //   AnimatedOpacity(
                //     opacity: vm.showHistoryButton ? 1 : 0,
                //     duration: const Duration(milliseconds: 200),
                //     child: CustomIconButton(
                //       onPressed: () async {
                //         await context.push(() => const ReceiveHistoryPage());
                //       },
                //       child: const Icon(Icons.history),
                //     ),
                //   ),
                CustomIconButton(
                  key: const ValueKey('info-btn'),
                  onPressed: () {
                    showAdvanced.value = !showAdvanced.value;
                  },
                  child: const Icon(Icons.info),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
