import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddressFieldWidget extends StatelessWidget {
  final TextEditingController ipTextController;
  final TextEditingController portTextController;
  final Color? backgroundColor;

  final bool? isEnableIP;
  final bool? isEnablePort;

  const AddressFieldWidget({
    super.key,
    required this.ipTextController,
    required this.portTextController,
    this.isEnableIP,
    this.isEnablePort,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: isEnableIP ?? true,
            controller: ipTextController,
            keyboardType: kIsWeb
                ? const TextInputType.numberWithOptions(signed: true)
                : Platform.isIOS
                    ? const TextInputType.numberWithOptions(signed: true)
                    : const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: '192.168.1.100',
              hintStyle: const TextStyle(color: Colors.black26),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.2), width: 1.2),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.2), width: 1.2),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: backgroundColor != null,
              fillColor: backgroundColor,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          width: 72.0,
          child: TextField(
            enabled: isEnablePort ?? true,
            controller: portTextController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: '8080',
              hintStyle: const TextStyle(color: Colors.black26),
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.2), width: 1.2),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.2), width: 1.2),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: backgroundColor != null,
              fillColor: backgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
