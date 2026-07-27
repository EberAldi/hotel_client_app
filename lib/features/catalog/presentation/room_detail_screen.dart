import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/auth/auth_gate.dart';
import '../../../core/config/app_theme.dart';
import '../../reservations/data/payment_api.dart';
import '../../reservations/data/reservation_api.dart';
import '../../reviews/data/review_models.dart';
import '../../reviews/providers/review_providers.dart';
import '../data/catalog_models.dart';
import '../providers/catalog_providers.dart';
import 'room_image.dart';

class RoomDetailScreen extends ConsumerStatefulWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends ConsumerState<RoomDetailScreen> {
  static final _fechaLegible = DateFormat('d MMM yyyy', 'es_MX');

  @override
  Widget build(BuildContext context) {
    final habitacionAsync = ref.watch(habitacionPorIdProvider(widget.roomId));

    return Scaffold(
      body: habitacionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No pudimos cargar esta habitación.\n$err', textAlign: TextAlign.center),
          ),
        ),
        data: (room) => _RoomDetailContent(room: room, fechaLegible: _fechaLegible, onReservar: () => _reservar(room)),
      ),
    );
  }

  Future<void> _reservar(Habitacion room) async {
    final canProceed = await requireAuth(
      context, ref,
      actionLabel: 'Necesitas iniciar sesión para reservar esta habitación.',
    );
    if (!canProceed || !mounted) return;

    final hoy = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(hoy.year, hoy.month, hoy.day),
      lastDate: hoy.add(const Duration(days: 365)),
      helpText: 'Elige tus fechas',
      saveText: 'Continuar',
    );
    if (rango == null || !mounted) return;

    final noches = rango.duration.inDays;
    if (noches < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La salida debe ser al menos un día después de la entrada.')),
      );
      return;
    }

    final precioTotal = noches * room.precioBase;
    await _confirmarReserva(room: room, entrada: rango.start, salida: rango.end, noches: noches, precioTotal: precioTotal);
  }

  Future<void> _confirmarReserva({
    required Habitacion room,
    required DateTime entrada,
    required DateTime salida,
    required int noches,
    required double precioTotal,
  }) async {
    bool enviando = false;
    String metodo = 'efectivo';
    final numeroTarjetaController = TextEditingController();
    final vencimientoController = TextEditingController();
    final cvvController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 28, right: 28, top: 28,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Confirma tu reservación', style: Theme.of(ctx).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              _resumenFila('Habitación', '${room.tipoNombre} · ${room.numero}'),
              _resumenFila('Entrada', _fechaLegible.format(entrada)),
              _resumenFila('Salida', _fechaLegible.format(salida)),
              _resumenFila('Noches', '$noches'),
              const Divider(height: 28),
              _resumenFila('Total', '\$${precioTotal.toStringAsFixed(0)} MXN', destacado: true),
              const SizedBox(height: 20),
              Text('Método de pago', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontSize: 15)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetodoPagoOpcion(
                      label: 'Efectivo',
                      icon: Icons.payments_outlined,
                      selected: metodo == 'efectivo',
                      onTap: () => setSheetState(() => metodo = 'efectivo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetodoPagoOpcion(
                      label: 'Tarjeta',
                      icon: Icons.credit_card_rounded,
                      selected: metodo == 'tarjeta',
                      onTap: () => setSheetState(() => metodo = 'tarjeta'),
                    ),
                  ),
                ],
              ),
              if (metodo == 'tarjeta') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: numeroTarjetaController,
                  decoration: const InputDecoration(hintText: 'Número de tarjeta', prefixIcon: Icon(Icons.credit_card_rounded)),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: vencimientoController,
                        decoration: const InputDecoration(hintText: 'MM/AA'),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: const InputDecoration(hintText: 'CVV'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 3,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Pago simulado: no se realiza ningún cargo real.',
                  style: Theme.of(ctx).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const SizedBox(height: 12),
                Text(
                  'Tu reservación quedará pendiente de pago. Pagas al llegar al hotel.',
                  style: Theme.of(ctx).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: enviando
                    ? null
                    : () async {
                        if (metodo == 'tarjeta' &&
                            !_tarjetaSimuladaValida(
                              numeroTarjetaController.text,
                              vencimientoController.text,
                              cvvController.text,
                            )) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text('Revisa los datos de la tarjeta.')),
                          );
                          return;
                        }

                        setSheetState(() => enviando = true);
                        try {
                          final reservacion = await ref.read(reservationApiProvider).crearReservacion(
                                habitacionId: room.id,
                                fechaEntrada: entrada,
                                fechaSalida: salida,
                                precioTotal: precioTotal,
                              );
                          final pago = await ref.read(paymentApiProvider).crearPago(
                                reservacionId: reservacion['id'] as String,
                                monto: precioTotal,
                                metodo: metodo,
                              );

                          String mensajeExito;
                          if (metodo == 'tarjeta') {
                            final confirmacion = await ref.read(paymentApiProvider).confirmarPago(
                                  pago['id'] as String,
                                  idTransaccion: 'SIM-${DateTime.now().millisecondsSinceEpoch}',
                                );
                            mensajeExito = '¡Pago aprobado! Factura ${confirmacion['numero_factura']}.';
                          } else {
                            mensajeExito =
                                'Reservación creada. Paga \$${precioTotal.toStringAsFixed(0)} en efectivo al llegar.';
                          }

                          if (ctx.mounted) Navigator.pop(ctx);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensajeExito)));
                          }
                        } on DioException catch (e) {
                          setSheetState(() => enviando = false);
                          final detalle = e.response?.data is Map ? e.response?.data['detail'] : null;
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(detalle?.toString() ?? 'No pudimos procesar tu reservación.')),
                            );
                          }
                        }
                      },
                child: enviando
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(metodo == 'tarjeta' ? 'Pagar con tarjeta' : 'Reservar y pagar en efectivo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _tarjetaSimuladaValida(String numero, String vencimiento, String cvv) {
    final numeroLimpio = numero.replaceAll(RegExp(r'\s'), '');
    final vencimientoValido = RegExp(r'^\d{2}/\d{2}$').hasMatch(vencimiento);
    return numeroLimpio.length >= 13 && numeroLimpio.length <= 19 && vencimientoValido && cvv.length >= 3;
  }

  Widget _resumenFila(String label, String valor, {bool destacado = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.ink.withOpacity(0.7))),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: destacado ? 18 : 14,
              color: destacado ? AppColors.terracotta : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetodoPagoOpcion extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MetodoPagoOpcion({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.terracotta.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.terracotta : AppColors.ink.withOpacity(0.15), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.terracotta : AppColors.ink.withOpacity(0.6)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.terracotta : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomDetailContent extends ConsumerWidget {
  final Habitacion room;
  final DateFormat fechaLegible;
  final VoidCallback onReservar;

  const _RoomDetailContent({required this.room, required this.fechaLegible, required this.onReservar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipoAsync = ref.watch(tipoHabitacionProvider(room.tipoId));
    final imagenesAsync = ref.watch(imagenesPorHabitacionProvider);
    final resenasAsync = ref.watch(resenasHabitacionesProvider);

    final imagenPrincipal = imagenesAsync.value?[room.id]?.firstWhere(
      (img) => img.esPrincipal,
      orElse: () => imagenesAsync.value![room.id]!.first,
    );
    final resenas = resenasAsync.value?[room.id] ?? const <Resena>[];
    final avgRating = resenas.isEmpty
        ? null
        : resenas.map((r) => r.calificacion).reduce((a, b) => a + b) / resenas.length;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          backgroundColor: AppColors.cream,
          flexibleSpace: FlexibleSpaceBar(
            background: RoomImage(imageUrl: imagenPrincipal?.url, tipoNombre: room.tipoNombre),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${room.tipoNombre} · Habitación ${room.numero}', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.cempasuchil, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      avgRating == null
                          ? 'Aún sin reseñas'
                          : '${avgRating.toStringAsFixed(1)}  ·  ${resenas.length} reseñas',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                tipoAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (tipo) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tipo.descripcion.isNotEmpty) ...[
                        Text(tipo.descripcion, style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 12),
                      ],
                      Chip(
                        avatar: const Icon(Icons.people_alt_rounded, size: 18, color: AppColors.canteraGreen),
                        label: Text('Hasta ${tipo.capacidadMaxima} huéspedes'),
                        backgroundColor: AppColors.canteraGreen.withOpacity(0.12),
                        labelStyle: const TextStyle(color: AppColors.canteraGreen, fontWeight: FontWeight.w600),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onReservar,
                    child: Text('Reservar · \$${room.precioBase.toStringAsFixed(0)} / noche'),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reseñas', style: Theme.of(context).textTheme.headlineMedium),
                    TextButton(
                      onPressed: () => _openReviewSheet(context, ref),
                      child: const Text('Escribir reseña'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                resenasAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('No pudimos cargar las reseñas.', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  data: (_) => resenas.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text('Aún no hay reseñas para esta habitación.', style: Theme.of(context).textTheme.bodyMedium),
                        )
                      : Column(children: resenas.map((r) => _ReviewTile(review: r)).toList()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openReviewSheet(BuildContext context, WidgetRef ref) async {
    final canProceed = await requireAuth(
      context, ref,
      actionLabel: 'Necesitas iniciar sesión para dejar una reseña.',
    );
    if (!canProceed || !context.mounted) return;

    double rating = 5;
    final commentController = TextEditingController();
    bool enviando = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
                onPressed: enviando
                    ? null
                    : () async {
                        setSheetState(() => enviando = true);
                        try {
                          await ref.read(reviewApiProvider).crearResena(
                                tipoObjetivo: 'HABITACION',
                                objetivoId: room.id,
                                calificacion: rating.round(),
                                comentario: commentController.text,
                              );
                          ref.invalidate(resenasHabitacionesProvider);
                          if (ctx.mounted) Navigator.pop(ctx);
                        } on DioException catch (e) {
                          setSheetState(() => enviando = false);
                          final detalle = e.response?.data is Map ? e.response?.data['detail'] : null;
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(detalle?.toString() ?? 'No pudimos enviar tu reseña.')),
                            );
                          }
                        }
                      },
                child: enviando
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Enviar reseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Resena review;
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
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0x26C1502E),
                child: Icon(Icons.person_rounded, size: 18, color: AppColors.terracotta),
              ),
              const SizedBox(width: 10),
              const Text('Huésped', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < review.calificacion ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 16, color: AppColors.cempasuchil,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comentario, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
