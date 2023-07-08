import 'dart:io';

import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key, required this.uploadFile});
  final File uploadFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(uploadFile.toString()));
  }
}
