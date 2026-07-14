import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_client_app/features/assistant/presentation/chat_screen.dart';
import 'package:hotel_client_app/features/assistant/presentation/weather_recomendation.dart';
import '../../../core/config/app_theme.dart';
import '../data/mock_data.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const ChatScreen()),
  ),
  backgroundColor: AppColors.terracotta,
  icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
  label: const Text('Asistente', style: TextStyle(color: Colors.white)),
),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.cream,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1512813195386-6cf811ad3542?w=1000',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.55)],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 20, bottom: 20, right: 20,
                    child: Text(
                      'Casa del Centro',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'DMSerifDisplay'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'A pasos del Zócalo de Oaxaca',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const WeatherRecommendationCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          _sectionTitle(context, 'Habitaciones destacadas'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockRooms.length,
                itemBuilder: (context, i) => _RoomCard(room: mockRooms[i]),
              ),
            ),
          ),
          _sectionTitle(context, 'Descubre el centro histórico'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockAttractions.length,
                itemBuilder: (context, i) => _AttractionCard(attraction: mockAttractions[i]),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
      );
}

class _RoomCard extends StatelessWidget {
  final Room room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/room/${room.id}'),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: CachedNetworkImage(imageUrl: room.imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16), maxLines: 1),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.cempasuchil),
                      const SizedBox(width: 4),
                      Text('${room.avgRating} (${room.reviewCount})', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('\$${room.pricePerNight.toStringAsFixed(0)} / noche',
                      style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final Attraction attraction;
  const _AttractionCard({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(image: CachedNetworkImageProvider(attraction.imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
          ),
        ),
        padding: const EdgeInsets.all(14),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(attraction.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(attraction.distance, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}