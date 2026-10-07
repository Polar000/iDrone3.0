import React, { useRef, useState } from 'react';
import { PROJECTS_GALLERY, ProjectItem } from '../../data/orvexaData';
import {
  ChevronLeft,
  ChevronRight,
  Maximize2,
  X,
  MapPin,
  Calendar,
  Layers,
  ShieldCheck,
  Zap,
} from 'lucide-react';

export function ProjectsSection() {
  const scrollContainerRef = useRef<HTMLDivElement>(null);
  const [selectedProject, setSelectedProject] = useState<ProjectItem | null>(null);

  const scroll = (direction: 'left' | 'right') => {
    if (scrollContainerRef.current) {
      const scrollAmount = direction === 'left' ? -480 : 480;
      scrollContainerRef.current.scrollBy({ left: scrollAmount, behavior: 'smooth' });
    }
  };

  return (
    <section id="projects" className="relative w-full bg-orvexa-black py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10 mb-12">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-orvexa-darkgray pb-8">
          <div>
            <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
              CASOS DE ÉXITO & PORTAFOLIO
            </span>
            <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight mt-2">
              PROJECTS
            </h2>
          </div>
          <div className="flex items-center gap-4">
            <p className="text-orvexa-lightgray text-sm hidden sm:block max-w-xs">
              Donde la maquinaria se convierte en resultados tangibles.
            </p>

            {/* Gallery Navigation Controls */}
            <div className="flex items-center gap-2">
              <button
                onClick={() => scroll('left')}
                className="p-3 bg-orvexa-graphite border border-orvexa-darkgray hover:border-orvexa-yellow hover:text-orvexa-yellow text-orvexa-white transition-colors"
                title="Proyectos anteriores"
              >
                <ChevronLeft className="w-5 h-5" />
              </button>
              <button
                onClick={() => scroll('right')}
                className="p-3 bg-orvexa-graphite border border-orvexa-darkgray hover:border-orvexa-yellow hover:text-orvexa-yellow text-orvexa-white transition-colors"
                title="Siguientes proyectos"
              >
                <ChevronRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Horizontal Scrolling Gallery Container */}
      <div
        ref={scrollContainerRef}
        className="flex gap-8 overflow-x-auto snap-x snap-mandatory px-6 md:px-12 pb-8 scrollbar-none no-scrollbar"
        style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
      >
        {PROJECTS_GALLERY.map((proj) => (
          <div
            key={proj.id}
            onClick={() => setSelectedProject(proj)}
            className="group shrink-0 w-[85vw] sm:w-[500px] md:w-[620px] snap-center bg-orvexa-graphite border border-orvexa-darkgray hover:border-orvexa-yellow transition-all duration-500 overflow-hidden cursor-pointer flex flex-col justify-between"
          >
            <div>
              {/* Full-bleed Project Image */}
              <div className="relative h-[280px] sm:h-[340px] overflow-hidden bg-orvexa-black">
                <img
                  src={proj.image}
                  alt={proj.title}
                  className="w-full h-full object-cover opacity-65 group-hover:opacity-90 group-hover:scale-105 transition-all duration-700"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-orvexa-graphite via-transparent to-transparent" />

                {/* Number Badge */}
                <span className="absolute top-4 left-4 bg-orvexa-black/90 border border-orvexa-darkgray text-orvexa-yellow font-mono text-xs font-bold px-3 py-1.5 backdrop-blur-md">
                  {proj.number}
                </span>

                <div className="absolute bottom-4 right-4 bg-orvexa-black/80 border border-orvexa-darkgray p-2 text-orvexa-yellow group-hover:bg-orvexa-yellow group-hover:text-orvexa-black transition-colors">
                  <Maximize2 className="w-4 h-4" />
                </div>
              </div>

              {/* Project Card Text Content */}
              <div className="p-6 md:p-8 space-y-4">
                <div className="flex items-center gap-3 text-xs font-mono text-orvexa-yellow">
                  <MapPin className="w-3.5 h-3.5" />
                  <span>{proj.location}</span>
                  <span>•</span>
                  <span>{proj.type}</span>
                </div>

                <h3 className="text-2xl font-display font-black text-orvexa-white group-hover:text-orvexa-yellow transition-colors leading-snug">
                  {proj.title}
                </h3>

                <p className="text-xs text-orvexa-lightgray line-clamp-2 leading-relaxed">
                  {proj.description}
                </p>

                {/* Services Pills */}
                <div className="flex flex-wrap gap-2 pt-2">
                  {proj.services.map((srv, idx) => (
                    <span
                      key={idx}
                      className="bg-orvexa-black border border-orvexa-darkgray/80 text-[10px] font-mono text-orvexa-lightgray px-2.5 py-1"
                    >
                      {srv}
                    </span>
                  ))}
                </div>
              </div>
            </div>

            {/* Bottom Card Footer */}
            <div className="p-6 md:p-8 pt-0 flex items-center justify-between border-t border-orvexa-darkgray/60 font-mono text-xs">
              <span className="text-orvexa-lightgray">ESCALA: {proj.volumeOrScale}</span>
              <span className="text-orvexa-yellow font-bold">VER DETALLES →</span>
            </div>
          </div>
        ))}
      </div>

      {/* Project Lightbox Detail Modal */}
      {selectedProject && (
        <div className="fixed inset-0 z-[100] bg-orvexa-black/90 backdrop-blur-xl flex items-center justify-center p-4 md:p-8 animate-in fade-in duration-200">
          <div className="bg-orvexa-graphite border border-orvexa-yellow max-w-4xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-10 relative space-y-6">
            <button
              onClick={() => setSelectedProject(null)}
              className="absolute top-6 right-6 p-2 bg-orvexa-black text-orvexa-white hover:text-orvexa-yellow border border-orvexa-darkgray"
            >
              <X className="w-6 h-6" />
            </button>

            <span className="bg-orvexa-yellow text-orvexa-black font-mono font-bold text-xs px-3 py-1 inline-block">
              {selectedProject.number} • {selectedProject.type}
            </span>

            <h3 className="text-3xl md:text-5xl font-display font-black text-orvexa-white">
              {selectedProject.title}
            </h3>

            <div className="relative h-64 md:h-96 w-full overflow-hidden bg-orvexa-black border border-orvexa-darkgray">
              <img
                src={selectedProject.image}
                alt={selectedProject.title}
                className="w-full h-full object-cover"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 bg-orvexa-black p-4 border border-orvexa-darkgray font-mono text-xs">
              <div>
                <span className="text-orvexa-lightgray block">UBICACIÓN:</span>
                <span className="text-orvexa-white font-bold">{selectedProject.location}</span>
              </div>
              <div>
                <span className="text-orvexa-lightgray block">ALCANCE / ESCALA:</span>
                <span className="text-orvexa-yellow font-bold">{selectedProject.volumeOrScale}</span>
              </div>
              <div>
                <span className="text-orvexa-lightgray block">DURACIÓN:</span>
                <span className="text-orvexa-white font-bold">{selectedProject.duration}</span>
              </div>
            </div>

            <div className="space-y-3">
              <h4 className="text-xs font-mono text-orvexa-yellow tracking-widest uppercase">
                DESCRIPCIÓN TÉCNICA DEL PROYECTO:
              </h4>
              <p className="text-sm text-orvexa-lightgray leading-relaxed">
                {selectedProject.description}
              </p>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}

// "THE ORVEXA STANDARD" Minimalist Typography Section
export function OrvexaStandardSection() {
  const pillars = [
    {
      title: 'POWER',
      subtitle: 'CAPACIDAD PARA TRABAJOS EXIGENTES',
      desc: 'Maquinaria de alto tonelaje y respuesta inmediata ante demandas operacionales extremas.',
    },
    {
      title: 'PRECISION',
      subtitle: 'OPERACIONES ORIENTADAS A RESULTADOS',
      desc: 'Sistemas de control con telemetría GPS e ingeniería de detalle para reducir desviaciones al mínimo.',
    },
    {
      title: 'RELIABILITY',
      subtitle: 'EQUIPOS Y SOLUCIONES DE MÁXIMA CONFIANZA',
      desc: 'Flotas modernas con soporte técnico preventivo in-situ 24/7 sin tiempo muerto.',
    },
    {
      title: 'SCALE',
      subtitle: 'PREPARADOS PARA PROYECTOS DE GRAN DIMENSIÓN',
      desc: 'Capacidad logística y financiera para respaldar proyectos de infraestructura crítica.',
    },
  ];

  return (
    <section id="standard" className="relative w-full bg-orvexa-graphite py-32 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        <div className="mb-20 text-center">
          <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
            THE ORVEXA STANDARD
          </span>
          <h2 className="text-6xl sm:text-8xl md:text-9xl font-display font-black text-orvexa-white tracking-tighter uppercase mt-2">
            BUILT <span className="text-orvexa-yellow">DIFFERENT.</span>
          </h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {pillars.map((item, idx) => (
            <div
              key={item.title}
              className="bg-orvexa-black border border-orvexa-darkgray p-10 hover:border-orvexa-yellow transition-all duration-300 space-y-4"
            >
              <div className="flex items-center justify-between border-b border-orvexa-darkgray pb-4">
                <h3 className="font-display font-black text-3xl text-orvexa-white tracking-tight">
                  {item.title}
                </h3>
                <span className="font-mono text-xs font-bold text-orvexa-yellow">
                  0{idx + 1}
                </span>
              </div>
              <p className="font-mono text-xs text-orvexa-yellow uppercase">
                {item.subtitle}
              </p>
              <p className="text-sm text-orvexa-lightgray leading-relaxed">
                {item.desc}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
