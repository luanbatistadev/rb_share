import 'dart:developer';

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
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  void goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: PageView(
            controller: _pageController,
            children: [
              ChooseFiles(
                callback: goToNextPage,
              ),
              SendModes(
                goToNextPage: goToNextPage,
                goToPreviosPage: goToPreviousPage,
              ),
              NearbyDevices(
                callback: goToNextPage,
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final currentPage = _pageController.page ?? 0;
            log(currentPage.toString());
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      width: currentPage < 1 ? 50 / (1 + currentPage) : 25,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      width: currentPage <= 1 ? 25 * (1 + currentPage) : 50 / currentPage,
                      height: 8,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      width: currentPage > 1 ? 50 / (3 - currentPage) : 25,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
