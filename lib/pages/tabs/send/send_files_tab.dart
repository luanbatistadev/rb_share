import 'package:flutter/material.dart';
import 'package:rb_share/pages/tabs/send/choose_file.dart';
import 'package:rb_share/pages/tabs/send/nearby_devices.dart';
import 'package:rb_share/pages/tabs/send/send_mode.dart';

class SendFilesTab extends StatefulWidget {
  const SendFilesTab({super.key});

  @override
  State<SendFilesTab> createState() => _SendFilesTabState();
}

class _SendFilesTabState extends State<SendFilesTab> {
  final _pageController = PageController();

  void goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Easing.emphasizedAccelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        ChooseFiles(
          callback: goToNextPage,
        ),
        SendModes(
          callback: goToNextPage,
        ),
        NearbyDevices(
          callback: goToNextPage,
        ),
      ],
    );
  }
}
