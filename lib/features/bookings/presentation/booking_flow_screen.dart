import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/pricing_engine.dart';
import '../../fields/presentation/map_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final String? initialService;

  const BookingFlowScreen({super.key, this.initialService});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;

  String _selectedService = 'Fumigación';
  String _selectedCrop = 'Maíz';
  String _selectedFarm = 'Finca El Paraíso';
  String _selectedParcel = 'Parcela Norte';
  double _areaM2 = 88060.0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeWindow = '08:00 AM - 11:00 AM';

  String _paymentMethod = 'card'; // 'card', 'transfer', 'deposit'
  final TextEditingController _cardNumberController = TextEditingController(text: '4532 •••• •••• 8821');
  final TextEditingController _cardHolderController = TextEditingController(text: 'Bryan Orellana');
  final TextEditingController _transferRefController = TextEditingController();

  final List<Map<String, String>> _services = [
    {
      'title': 'Fumigación',
      'desc': 'Aplicación precisa y uniforme de agroquímicos.',
      'icon': 'spray',
      'price': 'Q150/manzana',
    },
    {
      'title': 'Fertilización foliar',
      'desc': 'Mejora la nutrición y rendimiento de tus cultivos.',
      'icon': 'water_drop',
      'price': 'Q175/manzana',
    },
    {
      'title': 'Esparcimiento de granulados',
      'desc': 'Distribución eficiente de sólidos y semillas.',
      'icon': 'grain',
      'price': 'Q160/manzana',
    },
    {
      'title': 'Monitoreo agrícola',
      'desc': 'Conoce mejor el estado multiespectral de tu campo.',
      'icon': 'camera',
      'price': 'Q120/manzana',
    },
  ];

  final List<Map<String, String>> _crops = [
    {'name': 'Maíz', 'icon': 'corn'},
    {'name': 'Melón', 'icon': 'melon'},
    {'name': 'Caña de azúcar', 'icon': 'grass'},
    {'name': 'Pastos', 'icon': 'eco'},
    {'name': 'Café', 'icon': 'coffee'},
    {'name': 'Tomate', 'icon': 'tomato'},
    {'name': 'Hortalizas', 'icon': 'vegetables'},
    {'name': 'Otros', 'icon': 'more'},
  ];

  final List<String> _timeWindows = [
    '06:00 AM - 09:00 AM',
    '08:00 AM - 11:00 AM',
    '01:00 PM - 04:00 PM',
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _transferRefController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      if (widget.initialService == 'fertilization') {
        _selectedService = 'Fertilización foliar';
      } else if (widget.initialService == 'spreading') {
        _selectedService = 'Esparcimiento de granulados';
      } else if (widget.initialService == 'monitoring') {
        _selectedService = 'Monitoreo agrícola';
      }
    }
  }

  double _getServiceRate() {
    switch (_selectedService) {
      case 'Fertilización foliar':
        return 175.0;
      case 'Esparcimiento de granulados':
        return 160.0;
      case 'Monitoreo agrícola':
        return 120.0;
      default:
        return 150.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quote = PricingEngineService.calculateQuote(
      areaM2: _areaM2,
      pricePerManzana: _getServiceRate(),
      travelFee: 100.0,
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Paso ${_currentStep + 1} de 5'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 5.0,
              backgroundColor: AppColors.softGreen,
              color: AppColors.emerald,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(quote),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Anterior'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 4) {
                          setState(() => _currentStep++);
                        } else {
                          _confirmBooking(quote);
                        }
                      },
                      child: Text(_currentStep == 4 ? 'Pagar Anticipo (Q${quote.depositAmount.toStringAsFixed(2)})' : 'Siguiente'),
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

  Widget _buildStepContent(QuoteCalculation quote) {
    switch (_currentStep) {
      case 0:
        return _buildServiceSelectionStep();
      case 1:
        return _buildCropSelectionStep();
      case 2:
        return _buildParcelStep();
      case 3:
        return _buildScheduleStep();
      case 4:
        return _buildQuoteSummaryStep(quote);
      default:
        return const SizedBox();
    }
  }

  Widget _buildServiceSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona un servicio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
        const SizedBox(height: 6),
        const Text('Elige la aplicación tecnológica que requiere tu campo.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 20),
        ..._services.map((service) {
          final isSelected = _selectedService == service['title'];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isSelected ? AppColors.emerald : Colors.transparent,
                width: 2,
              ),
            ),
            color: isSelected ? AppColors.softGreen : AppColors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: isSelected ? AppColors.emerald : AppColors.softGreen,
                child: Icon(
                  service['title'] == 'Fumigación'
                      ? Icons.sanitizer_rounded
                      : service['title'] == 'Fertilización foliar'
                          ? Icons.water_drop_rounded
                          : service['title'] == 'Esparcimiento de granulados'
                              ? Icons.grain_rounded
                              : Icons.camera_alt_rounded,
                  color: isSelected ? AppColors.white : AppColors.deepForest,
                ),
              ),
              title: Text(service['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(service['desc']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(service['price']!, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 28) : null,
              onTap: () => setState(() => _selectedService = service['title']!),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCropSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona un cultivo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
        const SizedBox(height: 6),
        const Text('Adaptaremos la altura de vuelo y el volumen de descarga.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _crops.length,
          itemBuilder: (context, index) {
            final crop = _crops[index];
            final isSelected = _selectedCrop == crop['name'];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.emerald : Colors.transparent,
                  width: 2,
                ),
              ),
              color: isSelected ? AppColors.softGreen : AppColors.white,
              child: InkWell(
                onTap: () => setState(() => _selectedCrop = crop['name']!),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.agriculture_rounded,
                      color: isSelected ? AppColors.emerald : AppColors.deepForest,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      crop['name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? AppColors.deepForest : AppColors.dark,
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

  Widget _buildParcelStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona o dibuja tu parcela', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
        const SizedBox(height: 6),
        const Text('Puedes elegir una parcela guardada o delimitar una nueva en el mapa.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 20),

        Card(
          child: ListTile(
            leading: const Icon(Icons.landscape_rounded, color: AppColors.deepForest),
            title: Text('Parcela Seleccionada: $_selectedParcel'),
            subtitle: Text('Finca: $_selectedFarm • ${(QuoteCalculation(areaM2: _areaM2, areaManzanas: _areaM2 / 6988.96, areaHectares: _areaM2 / 10000, pricePerManzana: 150, subtotal: 0, travelFee: 0, discount: 0, total: 0, depositPercentage: 25, depositAmount: 0, balanceAmount: 0).areaManzanas).toStringAsFixed(2)} manzanas'),
            trailing: const Icon(Icons.check_circle_rounded, color: AppColors.emerald),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    isSelectionMode: true,
                    onPolygonSaved: (points, areaM2, parcelName) {
                      setState(() {
                        _areaM2 = areaM2;
                        _selectedParcel = parcelName;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.map_rounded),
            label: const Text('Dibujar nueva parcela en mapa'),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona fecha y horario', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
        const SizedBox(height: 6),
        const Text('Horarios disponibles según ventana operativa en tu zona.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 20),

        Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_month_rounded, color: AppColors.emerald),
            title: const Text('Fecha de servicio'),
            subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text('Ventana de horario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ..._timeWindows.map((tw) {
          final isSelected = _selectedTimeWindow == tw;
          return Card(
            color: isSelected ? AppColors.softGreen : AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSelected ? AppColors.emerald : Colors.transparent),
            ),
            child: ListTile(
              leading: const Icon(Icons.access_time_rounded, color: AppColors.deepForest),
              title: Text(tw, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald) : null,
              onTap: () => setState(() => _selectedTimeWindow = tw),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuoteSummaryStep(QuoteCalculation quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resumen y Pago de Anticipo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
        const SizedBox(height: 6),
        const Text('Revisa la cotización y selecciona tu método de pago.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        const SizedBox(height: 20),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSummaryRow('Servicio', _selectedService, isBold: true),
                _buildSummaryRow('Cultivo', _selectedCrop),
                _buildSummaryRow('Finca / Parcela', '$_selectedFarm / $_selectedParcel'),
                _buildSummaryRow('Área', '${quote.areaManzanas.toStringAsFixed(2)} manzanas (${quote.areaHectares.toStringAsFixed(2)} ha)'),
                _buildSummaryRow('Precio unitario', 'Q${quote.pricePerManzana.toStringAsFixed(2)} / manzana'),
                const Divider(height: 24),
                _buildSummaryRow('Subtotal', 'Q${quote.subtotal.toStringAsFixed(2)}'),
                _buildSummaryRow('Movilización (Zona Jutiapa)', 'Q${quote.travelFee.toStringAsFixed(2)}'),
                _buildSummaryRow('Descuento', '-Q${quote.discount.toStringAsFixed(2)}', color: AppColors.emerald),
                const Divider(height: 24),
                _buildSummaryRow('TOTAL SERVICIO', 'Q${quote.total.toStringAsFixed(2)}', isBold: true, fontSize: 18, color: AppColors.deepForest),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.softGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Anticipo a pagar hoy (25%)', 'Q${quote.depositAmount.toStringAsFixed(2)}', isBold: true, color: AppColors.deepForest),
                      const SizedBox(height: 4),
                      _buildSummaryRow('Saldo pendiente en sitio', 'Q${quote.balanceAmount.toStringAsFixed(2)}', color: AppColors.muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Método de Pago del Anticipo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepForest)),
        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _paymentMethod == 'card' ? AppColors.emerald : Colors.transparent, width: 2),
          ),
          color: _paymentMethod == 'card' ? AppColors.softGreen : AppColors.white,
          child: ListTile(
            leading: const Icon(Icons.credit_card_rounded, color: AppColors.emerald),
            title: const Text('Tarjeta de Crédito / Débito', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Procesamiento seguro e inmediato', style: TextStyle(fontSize: 12)),
            trailing: Radio<String>(
              value: 'card',
              groupValue: _paymentMethod,
              activeColor: AppColors.emerald,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            onTap: () => setState(() => _paymentMethod = 'card'),
          ),
        ),
        if (_paymentMethod == 'card')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              children: [
                TextField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(
                    labelText: 'Titular de la tarjeta',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de tarjeta',
                    prefixIcon: Icon(Icons.payment_rounded),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _paymentMethod == 'transfer' ? AppColors.emerald : Colors.transparent, width: 2),
          ),
          color: _paymentMethod == 'transfer' ? AppColors.softGreen : AppColors.white,
          child: ListTile(
            leading: const Icon(Icons.account_balance_rounded, color: AppColors.deepForest),
            title: const Text('Transferencia Bancaria / Banrural / BI', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Transferencia o depósito monetario', style: TextStyle(fontSize: 12)),
            trailing: Radio<String>(
              value: 'transfer',
              groupValue: _paymentMethod,
              activeColor: AppColors.emerald,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
            onTap: () => setState(() => _paymentMethod = 'transfer'),
          ),
        ),
        if (_paymentMethod == 'transfer')
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cuenta iDrone S.A.: Industrial Moneda Q - 012-345678-9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                TextField(
                  controller: _transferRefController,
                  decoration: const InputDecoration(
                    labelText: 'Número de boleta / referencia',
                    prefixIcon: Icon(Icons.receipt_long_rounded),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, double fontSize = 14, Color color = AppColors.dark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, color: AppColors.muted, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }

  void _confirmBooking(QuoteCalculation quote) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 48),
            ),
            const SizedBox(height: 16),
            const Text('Servicio Reservado con Éxito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.deepForest)),
            const SizedBox(height: 8),
            Text(
              'Hemos registrado tu anticipo de Q${quote.depositAmount.toStringAsFixed(2)}. Nuestro operador se pondrá en contacto pronto.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/my-services');
                },
                child: const Text('Ver mis servicios'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('Volver al inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
