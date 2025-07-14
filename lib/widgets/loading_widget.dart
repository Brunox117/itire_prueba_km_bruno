import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          'Consultando kilometraje...',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
