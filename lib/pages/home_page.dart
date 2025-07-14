import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itire_prueba_km_bruno/providers/mileage_provider.dart';
import 'package:itire_prueba_km_bruno/widgets/loading_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final mileageAsync = ref.watch(mileageProvider);
    final mileageNotifier = ref.read(mileageProvider.notifier);
    final isLoading = ref.watch(mileageProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Kilometraje')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botón para llamar la API
            !mileageNotifier.hasBeenCalled
                ? isLoading
                    ? LoadingWidget()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Bienvenido, aquí puedes consultar el kilometraje de la unidad 734455",
                            textAlign: TextAlign.center,
                            style: textStyles.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              mileageNotifier.fetchMileage();
                            },
                            child: const Text("Consultar Kilometraje"),
                          ),
                        ],
                      ),
                    )
                : SizedBox(),

            // Mostrar el estado de la consulta solo si se ha llamado
            if (mileageNotifier.hasBeenCalled)
              mileageAsync.when(
                data: (mileage) {
                  return Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          mileageNotifier.fetchMileage();
                        },
                        child: const Text("Volver a consultar"),
                      ),
                      const SizedBox(height: 16),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kilometraje Total:',
                        style: textStyles.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${mileage.toStringAsFixed(2)} km',
                        style: textStyles.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (mileageNotifier.mileageIncreased)
                        Text(
                          'El kilometraje aumento',
                          style: textStyles.bodyMedium,
                        ),
                    ],
                  );
                },
                loading: () => LoadingWidget(),
                error:
                    (error, stackTrace) => Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const SizedBox(height: 16),
                        Text(
                          textAlign: TextAlign.center,
                          'Hubo un error, porfavor vuelve a intentarlo',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            mileageNotifier.fetchMileage();
                          },
                          child: const Text("Volver a consultar"),
                        ),
                      ],
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
