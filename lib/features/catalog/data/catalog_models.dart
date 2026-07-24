class TipoHabitacion {
  final String id;
  final String nombre;
  final String descripcion;
  final int capacidadMaxima;

  const TipoHabitacion({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.capacidadMaxima,
  });

  factory TipoHabitacion.fromJson(Map<String, dynamic> json) => TipoHabitacion(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String? ?? '',
        capacidadMaxima: json['capacidad_maxima'] as int,
      );
}

class Habitacion {
  final String id;
  final String numero;
  final String tipoId;
  final String tipoNombre;
  final double precioBase;
  final String estado;

  const Habitacion({
    required this.id,
    required this.numero,
    required this.tipoId,
    required this.tipoNombre,
    required this.precioBase,
    required this.estado,
  });

  factory Habitacion.fromJson(Map<String, dynamic> json) => Habitacion(
        id: json['id'] as String,
        numero: json['numero'] as String,
        tipoId: json['tipo'] as String,
        tipoNombre: json['tipo_nombre'] as String,
        precioBase: double.parse(json['precio_base'].toString()),
        estado: json['estado'] as String,
      );
}

class ImagenHabitacion {
  final String id;
  final String habitacionId;
  final String url;
  final bool esPrincipal;

  const ImagenHabitacion({
    required this.id,
    required this.habitacionId,
    required this.url,
    required this.esPrincipal,
  });

  factory ImagenHabitacion.fromJson(Map<String, dynamic> json) => ImagenHabitacion(
        id: json['id'] as String,
        habitacionId: json['habitacion'] as String,
        url: json['imagen_url'] as String? ?? '',
        esPrincipal: json['es_principal'] as bool? ?? false,
      );
}
