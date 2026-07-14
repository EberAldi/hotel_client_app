import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_gate.dart';
import '../../../core/config/app_theme.dart';
import '../data/mock_data.dart';

class RoomDetailScreen extends ConsumerStatefulWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends ConsumerState<RoomDetailScreen> {
  late List<Review> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = mockReviews.where((r) => r.roomId == widget.roomId).toList();
  }

  Room get _room => mockRooms.firstWhere((r) => r.id == widget.roomId);

  @override
  Widget build(BuildContext context) {
    final room = _room;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.cream,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: room.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.5)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.cempasuchil, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${room.avgRating}  ·  ${room.reviewCount} reseñas',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(room.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  Text('Servicios', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities
                        .map((a) => Chip(
                              label: Text(a),
                              backgroundColor: AppColors.canteraGreen.withOpacity(0.12),
                              labelStyle: const TextStyle(color: AppColors.canteraGreen, fontWeight: FontWeight.w600),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final canProceed = await requireAuth(
                          context, ref,
                          actionLabel: 'Necesitas iniciar sesión para reservar esta habitación.',
                        );
                        if (canProceed && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Simulando flujo de reserva… (por conectar)')),
                          );
                        }
                      },
                      child: Text('Reservar · \$${room.pricePerNight.toStringAsFixed(0)} / noche'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reseñas', style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: () => _openReviewSheet(context),
                        child: const Text('Escribir reseña'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_reviews.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Aún no hay reseñas para esta habitación.', style: Theme.of(context).textTheme.bodyMedium),
                    )
                  else
                    ..._reviews.map((r) => _ReviewTile(review: r)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openReviewSheet(BuildContext context) async {
    final canProceed = await requireAuth(
      context, ref,
      actionLabel: 'Necesitas iniciar sesión para dejar una reseña.',
    );
    if (!canProceed || !context.mounted) return;

    double rating = 5;
    final commentController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Califica tu estancia', style: Theme.of(ctx).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Center(
              child: RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                itemSize: 34,
                itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: AppColors.cempasuchil),
                onRatingUpdate: (value) => rating = value,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Cuéntanos sobre tu experiencia…'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _reviews.insert(0, Review(
                    id: DateTime.now().toIso8601String(),
                    roomId: widget.roomId,
                    userName: 'Tú',
                    rating: rating,
                    comment: commentController.text,
                    date: DateTime.now(),
                  ));
                });
                Navigator.pop(ctx);
              },
              child: const Text('Enviar reseña'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.terracotta.withOpacity(0.15),
                child: Text(review.userName[0], style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < review.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 16, color: AppColors.cempasuchil,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 24),
        ],
      ),
    );
  }
}