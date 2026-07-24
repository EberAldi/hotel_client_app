import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/router.dart';
import 'core/config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_MX');
  runApp(const ProviderScope(child: HotelClientApp()));
}

class HotelClientApp extends ConsumerWidget {
  const HotelClientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Hotel Cliente',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}