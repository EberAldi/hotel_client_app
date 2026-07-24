class Resena {
  final String id;
  final String tipoObjetivo;
  final String objetivoId;
  final int calificacion;
  final String comentario;

  const Resena({
    required this.id,
    required this.tipoObjetivo,
    required this.objetivoId,
    required this.calificacion,
    required this.comentario,
  });

  factory Resena.fromJson(Map<String, dynamic> json) => Resena(
        id: json['id'] as String,
        tipoObjetivo: json['tipo_objetivo'] as String,
        objetivoId: json['objetivo_id'] as String,
        calificacion: json['calificacion'] as int,
        comentario: json['comentario'] as String? ?? '',
      );
}
