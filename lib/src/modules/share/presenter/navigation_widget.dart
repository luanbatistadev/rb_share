import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rb_share/src/core/entities/connection_status.dart';
import 'package:rb_share/src/core/utils/constants.dart';
import 'package:rb_share/src/core/utils/styles.dart';


class NavigationWidgets extends StatefulWidget {
  final ConnectionStatus connectionStatus;

  const NavigationWidgets({super.key, required this.connectionStatus});

  @override
  State<NavigationWidgets> createState() => _NavigationWidgetsState();
}

class _NavigationWidgetsState extends State<NavigationWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Builder(builder: (context) {
            final isConnected = widget.connectionStatus == ConnectionStatus.connected;
            return FloatingActionButton.extended(
              backgroundColor: isConnected
                ? Theme.of(context).colorScheme.primaryContainer
                : disabledButtonColor,
              heroTag: const Text('Send files'),
              onPressed: () => _onClickSend(),
              icon: Icon(Icons.send,
                  color: isConnected ? textIconButtonColor : textIconButtonColorActivated
              ),
              label: Text(
                'Send files',
                style: CommonTextStyle.textStyleNormal.copyWith(
                    color: isConnected ? textIconButtonColor : textIconButtonColorActivated,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _onClickSend() {
    if(widget.connectionStatus != ConnectionStatus.connected) return;
    context.pushNamed(mSendPath);
  }

}
