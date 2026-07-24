import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/config/app_theme.dart';

/// Muestra la imagen real de la habitación si catalog-service tiene una
/// cargada; si no (el catálogo demo no trae imágenes por defecto), cae en un
/// marcador visual con el tipo de habitación en vez de simular una foto.
class RoomImage extends StatelessWidget {
  final String? imageUrl;
  final String tipoNombre;
  final double? height;
  final double? width;
  final BorderRadius borderRadius;

  const RoomImage({
    super.key,
    required this.imageUrl,
    required this.tipoNombre,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(imageUrl: imageUrl!, height: height, width: width, fit: BoxFit.cover),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
        color: AppColors.canteraGreen.withOpacity(0.15),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hotel_rounded, color: AppColors.canteraGreen, size: 32),
            const SizedBox(height: 6),
            Text(
              tipoNombre,
              style: const TextStyle(color: AppColors.canteraGreen, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
