import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itire_prueba_km_bruno/providers/mileage_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: OutlinedButton(
        onPressed: () async {
          ref.read(mileageProvider.notifier).fetchMileage();
        },
        child: const Text("API CALL"),
      ),
    );
  }
}
