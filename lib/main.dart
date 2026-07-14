import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/router.dart';
import 'core/config/app_theme.dart';

void main() {
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