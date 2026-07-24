// Los atractivos turísticos no tienen microservicio propio (son contenido
// fijo del hotel sobre el centro de Oaxaca), a diferencia de habitaciones y
// reseñas que ya vienen de catalog-service / review-service.
class Attraction {
  final String name;
  final String description;
  final String imageUrl;
  final String distance;

  const Attraction({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.distance,
  });
}

final mockAttractions = [
  const Attraction(
    name: 'Templo de Santo Domingo',
    description: 'Joya del barroco novohispano, a unos pasos del hotel.',
    imageUrl: 'https://images.unsplash.com/photo-1518638150340-f706e86654de?w=600',
    distance: '650 m',
  ),
  const Attraction(
    name: 'Mercado 20 de Noviembre',
    description: 'El corazón gastronómico del centro histórico.',
    imageUrl: 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?w=600',
    distance: '400 m',
  ),
  const Attraction(
    name: 'Zócalo de Oaxaca',
    description: 'La plaza principal, rodeada de portales y cafés.',
    imageUrl: 'https://images.unsplash.com/photo-1543039625-14cbd3802e7d?w=600',
    distance: '300 m',
  ),
];
