import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../config/app_theme.dart';

/// Llama a esta función antes de cualquier acción que requiera sesión
/// (reservar, calificar, dejar review, favoritos, etc).
/// Devuelve true si el usuario ya puede continuar, false si se le pidió login.
Future<bool> requireAuth(BuildContext context, WidgetRef ref, {String? actionLabel}) async {
  final isLoggedIn = ref.read(authStateProvider).asData?.value ?? false;
  if (isLoggedIn) return true;

  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded, size: 42, color: AppColors.terracotta),
          const SizedBox(height: 16),
          Text(
            'Inicia sesión para continuar',
            style: Theme.of(ctx).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            actionLabel ?? 'Necesitas una cuenta para completar esta acción.',
            style: Theme.of(ctx).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Iniciar sesión / Registrarme'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Seguir explorando', style: TextStyle(color: AppColors.ink)),
          ),
        ],
      ),
    ),
  );

  if (result == true && context.mounted) {
    context.push('/login');
  }
  return false;
}