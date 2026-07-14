class Room {
  final String id;
  final String name;
  final String description;
  final double pricePerNight;
  final String imageUrl;
  final List<String> amenities;
  final double avgRating;
  final int reviewCount;

  const Room({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerNight,
    required this.imageUrl,
    required this.amenities,
    required this.avgRating,
    required this.reviewCount,
  });
}

class Review {
  final String id;
  final String roomId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.roomId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

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

final mockRooms = [
  Room(
    id: 'r1',
    name: 'Suite Cantera Verde',
    description: 'Habitación con vista al patio colonial, cantera verde local y terraza privada.',
    pricePerNight: 1850,
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
    amenities: ['Wifi', 'Terraza', 'Desayuno incluido', 'Aire acondicionado'],
    avgRating: 4.8,
    reviewCount: 34,
  ),
  Room(
    id: 'r2',
    name: 'Habitación Añil',
    description: 'Inspirada en el azul de las puertas coloniales del centro, con balcón a la calle.',
    pricePerNight: 1400,
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800',
    amenities: ['Wifi', 'Balcón', 'Escritorio'],
    avgRating: 4.6,
    reviewCount: 21,
  ),
  Room(
    id: 'r3',
    name: 'Suite Cempasúchil',
    description: 'La habitación más grande, con jacuzzi y decoración textil zapoteca.',
    pricePerNight: 2600,
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d33?w=800',
    amenities: ['Wifi', 'Jacuzzi', 'Desayuno incluido', 'Vista al Zócalo'],
    avgRating: 4.9,
    reviewCount: 52,
  ),
];

final mockReviews = [
  Review(
    id: 'rv1', roomId: 'r1', userName: 'Fernanda G.', rating: 5,
    comment: 'La ubicación es increíble, a 5 min caminando del Zócalo. El patio es hermoso.',
    date: DateTime(2026, 5, 12),
  ),
  Review(
    id: 'rv2', roomId: 'r1', userName: 'Carlos M.', rating: 4.5,
    comment: 'Muy cómoda, el desayuno con chocolate oaxaqueño fue un gran detalle.',
    date: DateTime(2026, 4, 2),
  ),
];

final mockAttractions = [
  Attraction(
    name: 'Templo de Santo Domingo',
    description: 'Joya del barroco novohispano a 8 min caminando.',
    imageUrl: 'https://images.unsplash.com/photo-1614977645540-7237d838f6ea?w=800',
    distance: '650 m',
  ),
  Attraction(
    name: 'Mercado Benito Juárez',
    description: 'Mezcal, quesillo y textiles locales, a un costado del Zócalo.',
    imageUrl: 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?w=800',
    distance: '400 m',
  ),
  Attraction(
    name: 'Zócalo de Oaxaca',
    description: 'El corazón del centro histórico, con música en vivo por las tardes.',
    imageUrl: 'https://images.unsplash.com/photo-1591825381318-e7ecc4a2c37c?w=800',
    distance: '200 m',
  ),
];