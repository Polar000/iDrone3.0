# iDrone 3.0 — Agricultura de Precisión como Servicio

Aplicación móvil y panel de administración web para **iDrone Guatemala**, plataforma de servicios agrícolas con drones (fumigación, fertilización foliar, esparcimiento de granulados y monitoreo agrícola).

---

## 🚀 Requisitos Previos

- **Flutter SDK**: 3.20.0 o superior (Canal `stable`)
- **Dart SDK**: 3.4.0 o superior
- **Navegador Web** (Google Chrome o Microsoft Edge) o dispositivo/emulador Android/iOS

---

## 🛠️ Instalación y Ejecución

1. **Obtener las dependencias del proyecto**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run -d chrome
   ```
   *Nota: También puedes seleccionar un dispositivo Android o Windows Desktop habilitado.*

3. **Ejecutar pruebas unitarias**:
   ```bash
   flutter test test/unit_test.dart
   ```

4. **Verificar análisis estático del código**:
   ```bash
   flutter analyze
   ```

---

## 🗄️ Base de Datos y Backend (Supabase / PostgreSQL + PostGIS)

Las migraciones SQL y esquemas de base de datos se encuentran en el directorio `supabase/migrations/`:

- `00001_initial_schema.sql`: Extensión PostGIS, tablas principales (`profiles`, `farms`, `fields`, `crops`, `services`, `pricing_rules`, `zones`, `bookings`, `operators`, `drones`, `routes`, `branding`, `app_media`, etc.).
- `00002_rls_and_seed.sql`: Políticas de Seguridad a Nivel de Fila (RLS) y datos semilla para cultivos, servicios y zonas operativas de Guatemala (Jutiapa, Pasaco, Moyuta, Jalpatagua).

Para aplicar las migraciones a tu instancia de Supabase:
```bash
supabase db push
```

---

## 📱 Módulos de la Aplicación

- **App Móvil Cliente**: Inicio con saludo dinámico y tarjeta Hero, selección de cultivos y servicios, mapa interactivo para delimitar parcelas y calcular áreas ($m^2$, hectáreas, manzanas), flujo de cotización con cálculo de anticipo (25%), seguimiento de servicio en tiempo real y visualización/impresión de reportes PDF.
- **App Operador**: Panel con lista de trabajos diarios, cambio de estado operativo (*En camino*, *En sitio*, *En aplicación*, *Completado*) y subida de fotografías.
- **Panel Web Administración**: Layout responsivo con barra lateral, métricas clave (ingresos, manzanas trabajadas, servicios), gráficos interactivos y módulos CRUD (Cultivos, Servicios, Precios, Promociones, Reservas, Operadores, Drones, Rutas, Zonas, Branding dinámico, Biblioteca de medios, Auditoría y Configuración).
