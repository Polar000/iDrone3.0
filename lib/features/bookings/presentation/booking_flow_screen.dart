import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/area_converter.dart';
import '../../../core/services/pricing_engine.dart';
import '../../../core/services/work_duration_calculator.dart';
import '../../../core/services/app_media_service.dart';
import '../../fields/presentation/map_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final String? initialService;

  const BookingFlowScreen({super.key, this.initialService});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final AppMediaService _mediaService = AppMediaService.instance;
  int _currentStep = 0;
  bool _isSavingBooking = false;

  // Selected State
  String? _selectedService = 'fumigation';
  String? _selectedCrop = 'Maíz';
  String? _selectedFarm = 'Finca El Paraíso';
  String _parcelName = 'Parcela Norte';
  double _areaM2 = 88060.0; // ~12.6 manzanas
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _timeWindow = '08:00 AM - 11:00 AM';
  String _paymentMethod = 'card'; // card, banrural, bi, cash
  String _couponCode = '';
  double _appliedDiscount = 0.0;
  bool _couponApplied = false;

  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _transferRefController = TextEditingController();

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'fumigation',
      'title': 'Fumigación',
      'desc': 'Aplicación precisa y uniforme contra plagas.',
      'icon': Icons.sanitizer_rounded,
      'mediaKey': 'service_fumigation',
      'color': AppColors.emerald,
    },
    {
      'id': 'fertilization',
      'title': 'Fertilización foliar',
      'desc': 'Nutrición directa para acelerar crecimiento.',
      'icon': Icons.water_drop_rounded,
      'mediaKey': 'service_fertilization',
      'color': AppColors.forest,
    },
    {
      'id': 'spreading',
      'title': 'Esparcimiento',
      'desc': 'Distribución eficiente de sólidos granulados.',
      'icon': Icons.grain_rounded,
      'mediaKey': 'service_spreading',
      'color': AppColors.earth,
    },
    {
      'id': 'monitoring',
      'title': 'Monitoreo agrícola',
      'desc': 'Mapeo multiespectral NDVI e inspección visual.',
      'icon': Icons.camera_alt_rounded,
      'mediaKey': 'service_monitoring',
      'color': AppColors.deepForest,
    },
  ];

  final List<Map<String, dynamic>> _crops = [
    {'name': 'Maíz', 'icon': Icons.grass_rounded, 'mediaKey': 'crop_maiz'},
    {'name': 'Melón', 'icon': Icons.nature_rounded, 'mediaKey': 'crop_melon'},
    {'name': 'Caña de azúcar', 'icon': Icons.agriculture_rounded, 'mediaKey': 'crop_cana'},
    {'name': 'Pastos', 'icon': Icons.eco_rounded, 'mediaKey': 'crop_pastos'},
    {'name': 'Café', 'icon': Icons.local_cafe_rounded, 'mediaKey': 'crop_cafe'},
    {'name': 'Tomate', 'icon': Icons.park_rounded, 'mediaKey': 'crop_tomate'},
    {'name': 'Hortalizas', 'icon': Icons.spa_rounded, 'mediaKey': 'crop_hortalizas'},
    {'name': 'Otros', 'icon': Icons.more_horiz_rounded, 'mediaKey': 'crop_otros'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null && widget.initialService!.isNotEmpty) {
      _selectedService = widget.initialService;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _transferRefController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'IDRONE2026' || code == 'CAMPO10') {
      setState(() {
        _couponCode = code;
        _couponApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cupón aplicado exitosamente! Descuento activo.'),
          backgroundColor: AppColors.emerald,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cupón no válido o expirado.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmAndSaveBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  Future<void> _confirmAndSaveBooking() async {
    setState(() => _isSavingBooking = true);
    final areaManzanas = AreaConverter.squareMetersToManzanas(_areaM2);
    final basePricePerMz = 150.0;
    final quote = PricingEngineService.calculateQuote(
      areaM2: _areaM2,
      pricePerManzana: basePricePerMz,
      travelFee: 100.0,
      discount: _couponApplied ? 150.0 : 0.0,
      depositPercentage: 25.0,
    );

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      // 1. Resolve or Create active Farm UUID
      String farmId;
      final farmRes = await supabase.from('farms').select('id').limit(1);
      if (farmRes is List && farmRes.isNotEmpty) {
        farmId = farmRes.first['id'];
      } else {
        final newFarm = await supabase.from('farms').insert({
          'owner_id': user?.id,
          'name': 'Finca El Paraíso',
          'description': 'Finca principal registrada',
          'location': 'Jutiapa, Guatemala',
        }).select('id').single();
        farmId = newFarm['id'];
      }

      // 2. Resolve or Create active Field UUID
      String fieldId;
      final fieldRes = await supabase.from('fields').select('id').eq('farm_id', farmId).limit(1);
      if (fieldRes is List && fieldRes.isNotEmpty) {
        fieldId = fieldRes.first['id'];
      } else {
        final newField = await supabase.from('fields').insert({
          'farm_id': farmId,
          'name': _parcelName,
          'area_m2': _areaM2,
          'area_ha': AreaConverter.squareMetersToHectares(_areaM2),
          'area_manzanas': areaManzanas,
        }).select('id').single();
        fieldId = newField['id'];
      }

      // 3. Resolve active Service UUID
      String serviceId = '00000000-0000-0000-0000-000000000201'; // Default Fumigation Seed UUID
      final serviceRes = await supabase.from('services').select('id').eq('service_type', _selectedService ?? 'fumigation').limit(1);
      if (serviceRes is List && serviceRes.isNotEmpty) {
        serviceId = serviceRes.first['id'];
      }

      final bookingRecord = {
        'customer_id': user?.id,
        'farm_id': farmId,
        'field_id': fieldId,
        'service_id': serviceId,
        'scheduled_date': _selectedDate.toIso8601String().split('T').first,
        'time_window_start': _timeWindow.split(' - ').first,
        'time_window_end': _timeWindow.split(' - ').last,
        'area_m2': _areaM2,
        'area_ha': AreaConverter.squareMetersToHectares(_areaM2),
        'area_manzanas': areaManzanas,
        'price_per_unit': basePricePerMz,
        'subtotal': quote.subtotal,
        'travel_fee': quote.travelFee,
        'discount': quote.discount,
        'total': quote.total,
        'deposit_percentage': 25.0,
        'deposit_amount': quote.depositAmount,
        'balance_amount': quote.balanceAmount,
        'status': 'confirmed',
        'customer_notes': 'Reserva confirmada en iDrone.',
      };

      await supabase.from('bookings').insert(bookingRecord);

      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildConfirmationBottomSheet(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar la reserva en Supabase: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: AppColors.white,
            onPressed: _confirmAndSaveBooking,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSavingBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          'Solicitar Servicio — Paso ${_currentStep + 1} de 5',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _previousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Animated Step Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: List.generate(5, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.emerald : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.emerald.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(),
              ),
            ),

            // Navigation Bottom CTA Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: AppColors.modernShadow(blur: 16),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _previousStep,
                        child: const Text('Atrás', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepForest,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                      ),
                      onPressed: _isSavingBooking ? null : _nextStep,
                      child: _isSavingBooking
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStep == 4 ? 'Confirmar y Pagar' : 'Siguiente',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentStep == 4 ? Icons.lock_outline_rounded : Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildServiceSelectionStep();
      case 1:
        return _buildCropSelectionStep();
      case 2:
        return _buildParcelSelectionStep();
      case 3:
        return _buildScheduleSelectionStep();
      case 4:
        return _buildQuoteSummaryStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildServiceSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona un servicio',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        const Text(
          'Elige la tecnología de aplicación requerida para tu parcela.',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _services.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final service = _services[index];
            final isSelected = _selectedService == service['id'];
            final color = service['color'] as Color;
            final imgUrl = _mediaService.getMediaUrl(service['mediaKey'] as String);

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.softGreen : AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? AppColors.emerald : AppColors.borderLight,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected ? AppColors.modernShadow(color: AppColors.emerald.withValues(alpha: 0.15)) : [],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedService = service['id'];
                  });
                },
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imgUrl.startsWith('http')
                            ? Image.network(
                                imgUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: color.withValues(alpha: 0.15)),
                              )
                            : Image.asset(
                                imgUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: color.withValues(alpha: 0.15)),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.dark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service['desc'] as String,
                              style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, color: AppColors.white, size: 16),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCropSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona un cultivo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        const Text(
          'Ajustamos la velocidad de vuelo y calibración según el tipo de hoja.',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _crops.length,
          itemBuilder: (context, index) {
            final crop = _crops[index];
            final isSelected = _selectedCrop == crop['name'];
            final imgUrl = _mediaService.getMediaUrl(crop['mediaKey'] as String);

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.softGreen : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.emerald : AppColors.borderLight,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected ? AppColors.modernShadow(color: AppColors.emerald.withValues(alpha: 0.15)) : [],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCrop = crop['name'];
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imgUrl.startsWith('http')
                          ? Image.network(imgUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: AppColors.cream))
                          : Image.asset(imgUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: AppColors.cream)),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.dark.withValues(alpha: isSelected ? 0.75 : 0.60),
                              AppColors.dark.withValues(alpha: 0.85),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            crop['icon'] as IconData,
                            color: isSelected ? AppColors.freshGreen : AppColors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            crop['name'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildParcelSelectionStep() {
    final areaManzanas = AreaConverter.squareMetersToManzanas(_areaM2);
    final durationResult = WorkDurationCalculator.calculateDuration(
      areaM2: _areaM2,
      serviceType: _selectedService ?? 'fumigation',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona o dibuja la parcela',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        const Text(
          'Calculamos el área exacta por coordenadas geográficas GPS.',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.emerald, width: 2),
            boxShadow: AppColors.modernShadow(blur: 16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.map_rounded, color: AppColors.deepForest, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _parcelName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.dark),
                          ),
                          Text(_selectedFarm!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${areaManzanas.toStringAsFixed(2)} mz',
                      style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.deepForest),
                      const SizedBox(width: 6),
                      Text(
                        'Tiempo est. vuelo: ~${durationResult.formattedTotalTime}',
                        style: const TextStyle(color: AppColors.deepForest, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    '${durationResult.batterySwaps} cambio(s) batería',
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.emerald, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    isSelectionMode: true,
                    onPolygonSaved: (points, areaM2, name) {
                      setState(() {
                        _areaM2 = areaM2;
                        _parcelName = name;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.touch_app_rounded, color: AppColors.emerald),
            label: const Text('Dibujar / Editar Parcela en el Mapa', style: TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha y horario de aplicación',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        const Text(
          'Las mañanas ofrecen menores corrientes de viento y óptima absorción.',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: AppColors.modernShadow(blur: 12),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text('Ventana de horario disponible:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dark)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            '06:00 AM - 09:00 AM',
            '08:00 AM - 11:00 AM',
            '02:00 PM - 05:00 PM',
          ].map((window) {
            final isSelected = _timeWindow == window;
            return ChoiceChip(
              label: Text(window),
              selected: isSelected,
              selectedColor: AppColors.emerald,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isSelected ? AppColors.emerald : AppColors.borderLight),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _timeWindow = window;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuoteSummaryStep() {
    final areaManzanas = AreaConverter.squareMetersToManzanas(_areaM2);
    final basePricePerMz = 150.0;
    final quote = PricingEngineService.calculateQuote(
      areaM2: _areaM2,
      pricePerManzana: basePricePerMz,
      travelFee: 100.0,
      discount: _couponApplied ? 150.0 : 0.0,
      depositPercentage: 25.0,
    );

    final serviceItem = _services.firstWhere(
      (s) => s['id'] == _selectedService,
      orElse: () => _services.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cotización y Pago de Anticipo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        const Text(
          'Resumen transparente con cálculo de anticipo de garantía del 25%.',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Digital Receipt Ticket Design
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3), width: 1.5),
            boxShadow: AppColors.modernShadow(blur: 20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: AppColors.deepForest,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.receipt_long_rounded, color: AppColors.freshGreen, size: 22),
                        SizedBox(width: 8),
                        Text('Ticket de Cotización', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.freshGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('ID-2026-99', style: TextStyle(color: AppColors.freshGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildTicketRow('Servicio', serviceItem['title'] as String),
                    _buildTicketRow('Cultivo', _selectedCrop!),
                    _buildTicketRow('Área calculada', '${areaManzanas.toStringAsFixed(2)} manzanas'),
                    _buildTicketRow('Precio por manzana', 'Q${basePricePerMz.toStringAsFixed(2)}'),
                    const Divider(height: 24),
                    _buildTicketRow('Subtotal servicio', 'Q${quote.subtotal.toStringAsFixed(2)}'),
                    _buildTicketRow('Cargo de movilización (Jutiapa)', 'Q${quote.travelFee.toStringAsFixed(2)}'),
                    if (quote.discount > 0)
                      _buildTicketRow('Descuento de cupón', '-Q${quote.discount.toStringAsFixed(2)}', isDiscount: true),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total del Servicio', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.dark)),
                        Text('Q${quote.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.deepForest)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Deposit Highlight Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Anticipo a Pagar Hoy (25%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepForest)),
                              Text('Saldo restante el día del servicio en campo', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                            ],
                          ),
                          Text('Q${quote.depositAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.emerald)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Coupon Code Bar
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: 'Código de cupón (ej. IDRONE2026)',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: _applyCoupon,
              child: const Text('Aplicar', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Guatemala Modern Payment Selection Header
        const Text('Métodos de pago aceptados', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.dark)),
        const SizedBox(height: 12),

        // 1. Credit / Debit Card
        _buildPaymentOptionTile(
          id: 'card',
          title: 'Tarjeta de Crédito / Débito',
          subtitle: 'Visa y Mastercard (Pago seguro)',
          icon: Icons.credit_card_rounded,
          badgeText: 'Visa / MC',
          badgeColor: Colors.blue.shade800,
        ),
        if (_paymentMethod == 'card') ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Número de Tarjeta',
                    prefixIcon: const Icon(Icons.payment_rounded, color: AppColors.emerald),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cardHolderController,
                  decoration: InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.emerald),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),

        // 2. Banrural
        _buildPaymentOptionTile(
          id: 'banrural',
          title: 'Banrural (Depósito / Transferencia)',
          subtitle: 'Cuenta Monetaria: 3033-019283-1',
          icon: Icons.account_balance_rounded,
          badgeText: 'Banrural',
          badgeColor: AppColors.banruralGreen,
        ),
        if (_paymentMethod == 'banrural') ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _transferRefController,
              decoration: InputDecoration(
                labelText: 'Número de Boleta o Referencia de Transferencia',
                prefixIcon: const Icon(Icons.receipt_rounded, color: AppColors.banruralGreen),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),

        // 3. Banco Industrial (BI)
        _buildPaymentOptionTile(
          id: 'bi',
          title: 'Banco Industrial (Transferencia / Convenio BI)',
          subtitle: 'Convenio BI #98231 — iDrone Guatemala',
          icon: Icons.account_balance_wallet_rounded,
          badgeText: 'BI / Bi en Línea',
          badgeColor: AppColors.biBlue,
        ),
        if (_paymentMethod == 'bi') ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _transferRefController,
              decoration: InputDecoration(
                labelText: 'Número de Transferencia Bi en Línea',
                prefixIcon: const Icon(Icons.pin_outlined, color: AppColors.biBlue),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),

        // 4. Cash
        _buildPaymentOptionTile(
          id: 'cash',
          title: 'Pago en Efectivo / En Sitio',
          subtitle: 'Pago directo al operador del dron al llegar al campo',
          icon: Icons.payments_rounded,
          badgeText: 'Efectivo',
          badgeColor: AppColors.earth,
        ),
      ],
    );
  }

  Widget _buildPaymentOptionTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required Color badgeColor,
  }) {
    final isSelected = _paymentMethod == id;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.softGreen : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppColors.emerald : AppColors.borderLight,
          width: isSelected ? 2.5 : 1,
        ),
        boxShadow: isSelected ? AppColors.modernShadow(color: AppColors.emerald.withValues(alpha: 0.12)) : [],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _paymentMethod = id;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: badgeColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.dark),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Radio<String>(
                value: id,
                groupValue: _paymentMethod,
                activeColor: AppColors.emerald,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _paymentMethod = val;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: isDiscount ? Colors.redAccent : AppColors.dark,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 56),
          ),
          const SizedBox(height: 18),
          const Text(
            '¡Servicio Reservado con Éxito!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.dark, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu solicitud ha sido registrada exitosamente en Supabase y asignada al sistema de despacho.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Digital Ticket Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                _buildTicketRow('Finca / Parcela', 'Finca El Paraíso — Parcela Norte'),
                _buildTicketRow('Fecha de Servicio', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                _buildTicketRow('Horario', _timeWindow),
                _buildTicketRow('Operador Asignado', 'Carlos Morales (Dron T30)'),
                _buildTicketRow('Estado de Pago', 'Anticipo Recibido'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pop(context);
                context.go('/my-services');
              },
              icon: const Icon(Icons.radar_rounded, color: AppColors.white),
              label: const Text('Rastrear Operación en Vivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.white)),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home');
              },
              child: const Text('Volver al Inicio', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
