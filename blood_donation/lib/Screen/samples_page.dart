import 'package:flutter/material.dart';

class SamplesPage extends StatelessWidget {
  const SamplesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Samples & Tutorials'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
      );
}
