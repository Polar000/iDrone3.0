export interface MachineItem {
  id: string;
  code: string;
  name: string;
  category: 'EXCAVADORAS' | 'BOBCATS' | 'RETROEXCAVADORAS' | 'PERFORACIÓN' | 'EQUIPO SOLAR';
  model: string;
  power: string;
  weight: string;
  capacity: string;
  applications: string[];
  availability: 'IMMEDIATE' | 'AVAILABLE' | 'RESERVED';
  availabilityText: string;
  description: string;
  modelType: 'excavator' | 'bobcat' | 'backhoe' | 'drilling' | 'solar';
  specs: { label: string; value: string }[];
  image: string;
}

export interface ServiceItem {
  code: string;
  id: string;
  title: string;
  subtitle: string;
  shortDesc: string;
  fullDesc: string;
  highlights: string[];
  image: string;
}

export interface RentalItem {
  id: string;
  category: 'EXCAVADORAS' | 'BOBCATS' | 'RETROEXCAVADORAS' | 'PERFORACIÓN';
  model: string;
  power: string;
  operatingWeight: string;
  applications: string[];
  availability: string;
  rateEstimate: string;
  image: string;
}

export interface ProjectItem {
  id: string;
  number: string;
  title: string;
  type: string;
  location: string;
  services: string[];
  description: string;
  volumeOrScale: string;
  duration: string;
  image: string;
}

export interface QuoteRequest {
  id: string;
  createdAt: string;
  name: string;
  company: string;
  phone: string;
  email: string;
  location: string;
  projectType: string;
  machineOrService: string;
  message: string;
  status: 'PENDING' | 'IN_REVIEW' | 'APPROVED';
}

export const FLEET_DATA: MachineItem[] = [
  {
    id: 'excavator-x500',
    code: 'POWER / 01',
    name: 'Excavadora ORVEXA X-500 Heavy',
    category: 'EXCAVADORAS',
    model: 'ORVEXA X-500 LC',
    power: '380 HP Turbo Diesel',
    weight: '38.5 Toneladas',
    capacity: '2.8 m³ Cucharón Reforzado',
    applications: [
      'Excavación masiva de minería y canteras',
      'Corte profundo de terrenos duros y rocosos',
      'Carga pesada de camiones articulados',
      'Preparación de infraestructura a gran escala'
    ],
    availability: 'IMMEDIATE',
    availabilityText: 'Disponible para despacho inmediato en sitio',
    description: 'Nuestra excavadora insignia diseñada para soportar las jornadas de trabajo pesado más exigentes sin interrupción.',
    modelType: 'excavator',
    specs: [
      { label: 'Potencia Motor', value: '380 HP @ 1800 rpm' },
      { label: 'Peso Operativo', value: '38,500 kg' },
      { label: 'Máx. Profundidad Excavación', value: '7.85 m' },
      { label: 'Fuerza de Desgarre', value: '245 kN' },
      { label: 'Capacidad Cucharón', value: '2.8 m³' },
      { label: 'Velocidad de Desplazamiento', value: '5.5 km/h' }
    ],
    image: 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'ctl-85-bobcat',
    code: 'POWER / 02',
    name: 'Minicargador ORVEXA CTL-85 Compact',
    category: 'BOBCATS',
    model: 'ORVEXA CTL-85 Ultra',
    power: '115 HP High-Flow',
    weight: '5.2 Toneladas',
    capacity: '1.4 Ton Carga Útil',
    applications: [
      'Nivelación fina y perfilado de terreno',
      'Limpieza rápida en accesos restringidos',
      'Soporte directo a hincado de estructuras solares',
      'Maniobras en obra civil urbana'
    ],
    availability: 'IMMEDIATE',
    availabilityText: 'Disponible en flota central',
    description: 'Máxima maniobrabilidad en orugas de goma reforzadas para terrenos inestables o espacios estrechos.',
    modelType: 'bobcat',
    specs: [
      { label: 'Potencia Motor', value: '115 HP Turbo' },
      { label: 'Peso Operativo', value: '5,200 kg' },
      { label: 'Capacidad de Carga', value: '1,450 kg' },
      { label: 'Flujo Hidráulico Alto', value: '140 L/min' },
      { label: 'Presión sobre Terreno', value: '0.34 bar' }
    ],
    image: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'backhoe-b90',
    code: 'POWER / 03',
    name: 'Retroexcavadora ORVEXA B-90 Versa',
    category: 'RETROEXCAVADORAS',
    model: 'ORVEXA B-90 HD 4x4',
    power: '130 HP Intercooler',
    weight: '9.8 Toneladas',
    capacity: '1.2 m³ / Cucharón Trasero 0.3 m³',
    applications: [
      'Apertura de zanjas para canalizaciones y tuberías',
      'Soporte multiusos en frentes de construcción',
      'Movimiento de materiales y nivelación de pistas',
      'Carga de camiones de volteo estándar'
    ],
    availability: 'AVAILABLE',
    availabilityText: 'Disponible para reserva proyectada',
    description: 'Equipamiento dual de alta precisión para tareas versátiles de preparación de suelo y excavación focalizada.',
    modelType: 'backhoe',
    specs: [
      { label: 'Potencia Motor', value: '130 HP' },
      { label: 'Profundidad de Zanja', value: '5.80 m' },
      { label: 'Fuerza Excavación Trasera', value: '64 kN' },
      { label: 'Tracción', value: '4x4 Integral con Bloqueo' }
    ],
    image: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'drilling-d800',
    code: 'POWER / 04',
    name: 'Perforadora Heavy Drill ORVEXA D-800',
    category: 'PERFORACIÓN',
    model: 'ORVEXA D-800 Rig',
    power: '450 HP Cummins Heavy Heavy',
    weight: '32.0 Toneladas',
    capacity: 'Profundidad hasta 50m / Ø1400mm',
    applications: [
      'Pilotaje de cimentación para puentes e infraestructura',
      'Perforación para anclajes de taludes',
      'Sondeos geomécanicos en roca pesada',
      'Infraestructura de energía y cimentaciones solares'
    ],
    availability: 'IMMEDIATE',
    availabilityText: 'Disponible con operador especializado',
    description: 'Torre hidráulica de torque extremo diseñada para atravesar estratos rocosos y concretar cimentaciones profundas.',
    modelType: 'drilling',
    specs: [
      { label: 'Torque de Perforación', value: '280 kNm' },
      { label: 'Diámetro Máximo', value: '1,400 mm' },
      { label: 'Profundidad Máxima', value: '50.0 m' },
      { label: 'Sistema de Tracción', value: 'Orugas Acero HD' }
    ],
    image: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'solar-pv300',
    code: 'POWER / 05',
    name: 'Hincadora Solar ORVEXA PV-300',
    category: 'EQUIPO SOLAR',
    model: 'ORVEXA PV-300 Solar Piler',
    power: '220 HP EcoDrive',
    weight: '14.5 Toneladas',
    capacity: 'Hincado GPS hasta 6.5m de poste',
    applications: [
      'Hincado automatizado de perfiles de acero para huertos solares',
      'Nivelación por coordenadas GPS Trimble/Topcon',
      'Instalación masiva de estructuras fotovoltaicas',
      'Perforación previa en terrenos rocosos para pilonas'
    ],
    availability: 'IMMEDIATE',
    availabilityText: 'Lista para despliegue en parques fotovoltaicos',
    description: 'Unidad de hincado de alta cadencia equipada con sensor de verticalidad autonivelante e integración GPS millimétrica.',
    modelType: 'solar',
    specs: [
      { label: 'Energía de Impacto', value: '1,950 Joules' },
      { label: 'Rendimiento Diario', value: 'Hasta 350 perfiles/día' },
      { label: 'Tolerancia Inclinación', value: '0.1 Grados con Auto-Laser' },
      { label: 'Compatibilidad Poste', value: 'Hasta 6,500 mm' }
    ],
    image: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80'
  }
];

export const SERVICES_DATA: ServiceItem[] = [
  {
    code: '01',
    id: 'heavy-equipment',
    title: 'HEAVY EQUIPMENT',
    subtitle: 'Capacidad operacional de alto tonelaje para megaproyectos.',
    shortDesc: 'Suministro y despliegue de maquinaria pesada de última generación para obras de gran envergadura.',
    fullDesc: 'Proveemos soluciones integrales de maquinaria pesada con soporte técnico continuo en campo. Nuestros equipos cuentan con sistemas de telemetría en tiempo real para optimizar ciclos de trabajo y consumo de combustible.',
    highlights: [
      'Excavadoras pesadas de 20 a 50 toneladas',
      'Flotas homogéneas con bajo horómetro de uso',
      'Mantenimiento preventivo in-situ 24/7',
      'Operadores certificados en altos estándares de seguridad'
    ],
    image: 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80'
  },
  {
    code: '02',
    id: 'equipment-rental',
    title: 'EQUIPMENT RENTAL',
    subtitle: 'Modalidades de alquiler flexibles por hora, día, mes o proyecto.',
    shortDesc: 'Alquiler de equipos con o sin operador, respaldados por contratos de disponibilidad garantizada.',
    fullDesc: 'Estructuramos esquemas de arrendamiento operativo adaptados a los flujos de caja y cronogramas de cada proyecto de infraestructura, garantizando sustitución rápida de equipo si las condiciones de obra lo exigen.',
    highlights: [
      'Contratos de alquiler de corto, mediano y largo plazo',
      'Planes llave en mano con combustible y mantenimiento',
      'Sustitución de unidad en menos de 24 horas',
      'Telemetría de rendimiento transparente'
    ],
    image: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80'
  },
  {
    code: '03',
    id: 'earthmoving',
    title: 'EARTHMOVING',
    subtitle: 'Preparación de sitio, desmonte, cortes y conformación de plataformas.',
    shortDesc: 'Ejecución de grandes volúmenes de movimiento de tierras con precisión volumétrica mediante modelos 3D.',
    fullDesc: 'Afrontamos proyectos de desmonte, excavación masiva, terraplenes y conformación de plataformas con un control estricto de cotas y densidades de compactación.',
    highlights: [
      'Modelado topográfico 3D y control por dron',
      'Nivelación y compactación de alta densidad',
      'Gestión integral de botaderos autorizados',
      'Capacidad de movimiento superior a 15,000 m³ diarios'
    ],
    image: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80'
  },
  {
    code: '04',
    id: 'drilling',
    title: 'DRILLING',
    subtitle: 'Perforación profunda, pilotaje y cimentación estructural.',
    shortDesc: 'Especialistas en perforación para cimentaciones complejas, estabilización de taludes y estudios de suelo.',
    fullDesc: 'Contamos con equipos de perforación rotativa y percusión de alto torque para ejecutar pilotes de gran diámetro y cimentaciones en terrenos rocosos o inestables.',
    highlights: [
      'Perforaciones de hasta 50 metros de profundidad',
      'Inyección de bentonita y encamisado de seguridad',
      'Anclajes en roca y drenes subhorizontales',
      'Equipos de impacto dinámico de alto rendimiento'
    ],
    image: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1200&q=80'
  },
  {
    code: '05',
    id: 'construction',
    title: 'CONSTRUCTION',
    subtitle: 'Infraestructura civil, puentes, vías y obras hidráulicas.',
    shortDesc: 'Desarrollo de obras de infraestructura pesada bajo rigurosos parámetros de ingeniería y cumplimiento.',
    fullDesc: 'Integramos maquinaria, personal clave y gestión de proyectos para construir carreteras, obras de drenaje mayor, puentes e instalaciones industriales.',
    highlights: [
      'Construcción de vías de acceso y plataformas industriales',
      'Obras de arte y drenaje pluvial masivo',
      'Infraestructura para sector energético e industrial',
      'Gestión bajo metodología BIM e ingeniería de valor'
    ],
    image: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=1200&q=80'
  },
  {
    code: '06',
    id: 'solar-projects',
    title: 'SOLAR PROJECTS',
    subtitle: 'Preparación de terreno, hincado y zanjado para parques fotovoltaicos.',
    shortDesc: 'Solución integral para el desarrollo de campos solares a gran escala, desde el despeje hasta el hincado.',
    fullDesc: 'Líderes en adecuación de terrenos e instalación de estructuras solares. Nuestra flota especializada realiza el hincado con guiado GPS para miles de postes diarios.',
    highlights: [
      'Adecuación y acondicionamiento topográfico de plantas PV',
      'Hincado automatizado de perfiles con precisión GPS',
      'Apertura de zanjas masivas para cableado de media tensión',
      'Construcción de subestaciones y caminos perimetrales'
    ],
    image: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80'
  }
];

export const RENTAL_CATALOG: RentalItem[] = [
  {
    id: 'rent-01',
    category: 'EXCAVADORAS',
    model: 'Excavadora ORVEXA X-500 Heavy',
    power: '380 HP',
    operatingWeight: '38.5 Ton',
    applications: ['Movimiento de tierras', 'Canteras', 'Cimentación'],
    availability: 'Disponible Inmediato',
    rateEstimate: 'Cotizar según contrato',
    image: 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=800&q=80'
  },
  {
    id: 'rent-02',
    category: 'BOBCATS',
    model: 'Minicargador CTL-85 Orugas',
    power: '115 HP',
    operatingWeight: '5.2 Ton',
    applications: ['Nivelación', 'Espacios reducidos', 'Soporte Solar'],
    availability: 'Disponible Inmediato',
    rateEstimate: 'Cotizar según contrato',
    image: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80'
  },
  {
    id: 'rent-03',
    category: 'RETROEXCAVADORAS',
    model: 'Retroexcavadora B-90 HD 4x4',
    power: '130 HP',
    operatingWeight: '9.8 Ton',
    applications: ['Zanjado', 'Carga', 'Servicios urbanos'],
    availability: 'Reserva 24h',
    rateEstimate: 'Cotizar según contrato',
    image: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=800&q=80'
  },
  {
    id: 'rent-04',
    category: 'PERFORACIÓN',
    model: 'Torre de Perforación Heavy Drill D-800',
    power: '450 HP',
    operatingWeight: '32.0 Ton',
    applications: ['Pilotes rocosos', 'Cimentación', 'Infraestructura'],
    availability: 'Disponible con Operador',
    rateEstimate: 'Cotizar según contrato',
    image: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=800&q=80'
  }
];

export const PROJECTS_GALLERY: ProjectItem[] = [
  {
    id: 'proj-01',
    number: 'PROYECTO 01',
    title: 'Parque Solar Fotovoltaico SOLARIA-120MW',
    type: 'Infraestructura Solar',
    location: 'Atacama Industrial Zone',
    services: ['Preparación de Terreno', 'Hincado GPS', 'Zanjado Masivo'],
    description: 'Adecuación de 240 hectáreas de terreno rocoso e hincado de más de 42,000 perfiles de acero para estructuras solares en un plazo récord de 90 días.',
    volumeOrScale: '240 Hectáreas / 42,000 Postes',
    duration: '4 Meses',
    image: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'proj-02',
    number: 'PROYECTO 02',
    title: 'Corredor Vial de Carga Pesada Norte',
    type: 'Movimiento de Tierras & Carreteras',
    location: 'Sector Industrial Metro',
    services: ['Excavación Masiva', 'Estabilización de Taludes', 'Pavimentación'],
    description: 'Movimiento de más de 1.8 millones de metros cúbicos de tierra y corte en roca para la creación de un nuevo eje logístico de 4 carriles.',
    volumeOrScale: '1,800,000 m³ Excavados',
    duration: '14 Meses',
    image: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'proj-03',
    number: 'PROYECTO 03',
    title: 'Cimentación Profunda Puerto Marítimo Terminal 4',
    type: 'Perforación & Pilotaje',
    location: 'Zona Portuaria Sur',
    services: ['Perforación de Pilotes', 'Vaciado Estructural', 'Draga Operativa'],
    description: 'Ejecución de 180 pilotes de 1,200 mm de diámetro a 42 metros de profundidad en lecho marino de rocas y arcillas expandibles.',
    volumeOrScale: '180 Pilotes Ø1200mm / 42m',
    duration: '8 Meses',
    image: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1200&q=80'
  },
  {
    id: 'proj-04',
    number: 'PROYECTO 04',
    title: 'Complejo Industrial & Plataforma Logística ORION',
    type: 'Construcción e Infraestructura',
    location: 'Parque Tecnológico',
    services: ['Corte y Relleno', 'Redes Subterráneas', 'Nivelación Láser'],
    description: 'Nivelación de plataforma industrial de 180,000 m² con tolerancia de +/- 5 mm para instalación de naves de almacenamiento robotizado.',
    volumeOrScale: '180,000 m² Plataforma Útil',
    duration: '6 Meses',
    image: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=1200&q=80'
  }
];

export const INITIAL_QUOTES: QuoteRequest[] = [
  {
    id: 'QUOTE-2025-001',
    createdAt: '2025-02-15 10:30',
    name: 'Carlos Mendoza',
    company: 'Constructora del Norte S.A.',
    phone: '+52 55 8920 1144',
    email: 'cmendoza@constructoranorte.com',
    location: 'Querétaro, MX',
    projectType: 'Parque Solar 80MW',
    machineOrService: 'SOLAR PROJECTS / Hincadora PV-300',
    message: 'Requerimos hincado de 18,000 perfiles y preparación de accesos para parque fotovoltaico.',
    status: 'IN_REVIEW'
  },
  {
    id: 'QUOTE-2025-002',
    createdAt: '2025-02-18 14:15',
    name: 'Ing. Sofía Reyes',
    company: 'Infraestructura Global',
    phone: '+57 311 450 9088',
    email: 'sreyes@infraglobal.co',
    location: 'Antioquia, CO',
    projectType: 'Perforación de Pilotes',
    machineOrService: 'DRILLING / Perforadora D-800',
    message: 'Cotización para 45 pilotes de 1,000mm a 35m de profundidad.',
    status: 'PENDING'
  }
];

// Helper functions for localized CMS store
const QUOTES_STORAGE_KEY = 'orvexa_quote_requests';

export function getQuoteRequests(): QuoteRequest[] {
  try {
    const saved = localStorage.getItem(QUOTES_STORAGE_KEY);
    if (saved) {
      return JSON.parse(saved);
    }
  } catch (e) {
    console.error('Error reading saved quotes:', e);
  }
  return INITIAL_QUOTES;
}

export function saveQuoteRequest(data: Omit<QuoteRequest, 'id' | 'createdAt' | 'status'>): QuoteRequest {
  const current = getQuoteRequests();
  const newQuote: QuoteRequest = {
    ...data,
    id: `QUOTE-${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`,
    createdAt: new Date().toISOString().replace('T', ' ').substring(0, 16),
    status: 'PENDING'
  };
  const updated = [newQuote, ...current];
  try {
    localStorage.setItem(QUOTES_STORAGE_KEY, JSON.stringify(updated));
  } catch (e) {
    console.error('Error saving quote:', e);
  }
  return newQuote;
}
