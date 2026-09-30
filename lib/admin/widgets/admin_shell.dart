import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool _isSidebarExpanded = true;
  bool _isAdminDarkMode = false;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_rounded, 'route': '/admin'},
    {'title': 'Clientes', 'icon': Icons.people_rounded, 'route': '/admin/customers'},
    {'title': 'Cultivos', 'icon': Icons.agriculture_rounded, 'route': '/admin/crops'},
    {'title': 'Servicios', 'icon': Icons.build_rounded, 'route': '/admin/services'},
    {'title': 'Precios', 'icon': Icons.sell_rounded, 'route': '/admin/pricing'},
    {'title': 'Promociones', 'icon': Icons.local_offer_rounded, 'route': '/admin/promotions'},
    {'title': 'Reservas', 'icon': Icons.event_available_rounded, 'route': '/admin/bookings'},
    {'title': 'Operadores', 'icon': Icons.engineering_rounded, 'route': '/admin/operators'},
    {'title': 'Drones', 'icon': Icons.air_rounded, 'route': '/admin/drones'},
    {'title': 'Rutas', 'icon': Icons.alt_route_rounded, 'route': '/admin/routes'},
    {'title': 'Zonas', 'icon': Icons.map_rounded, 'route': '/admin/zones'},
    {'title': 'Branding', 'icon': Icons.palette_rounded, 'route': '/admin/branding'},
    {'title': 'Biblioteca Media', 'icon': Icons.perm_media_rounded, 'route': '/admin/media'},
    {'title': 'Auditoría', 'icon': Icons.fact_check_rounded, 'route': '/admin/audit'},
    {'title': 'Configuración', 'icon': Icons.settings_rounded, 'route': '/admin/settings'},
  ];

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bgColor = _isAdminDarkMode ? AppColors.dark : AppColors.cream;
    final headerColor = _isAdminDarkMode ? const Color(0xFF1E293B) : AppColors.white;
    final textColor = _isAdminDarkMode ? AppColors.white : AppColors.dark;

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSidebarExpanded ? 240 : 70,
            color: AppColors.deepForest,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: _isSidebarExpanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    if (_isSidebarExpanded)
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'iDrone Admin',
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        _isSidebarExpanded ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                        color: AppColors.freshGreen,
                      ),
                      onPressed: () => setState(() => _isSidebarExpanded = !_isSidebarExpanded),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = currentRoute == item['route'];

                      return InkWell(
                        onTap: () => context.go(item['route'] as String),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: isSelected ? AppColors.emerald : Colors.transparent,
                          child: Row(
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: isSelected ? AppColors.white : AppColors.cream,
                                size: 22,
                              ),
                              if (_isSidebarExpanded) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      color: isSelected ? AppColors.white : AppColors.cream,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isSidebarExpanded)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.freshGreen,
                        side: const BorderSide(color: AppColors.freshGreen),
                      ),
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.smartphone_rounded, size: 18),
                      label: const Text('Ir a App Móvil', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: headerColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Panel de Control Operacional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(_isAdminDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: AppColors.emerald),
                            tooltip: _isAdminDarkMode ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro',
                            onPressed: () => setState(() => _isAdminDarkMode = !_isAdminDarkMode),
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.deepForest,
                            child: Text('SA', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text('Super Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
