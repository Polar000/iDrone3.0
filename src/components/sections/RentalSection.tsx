import React, { useState } from 'react';
import { RENTAL_CATALOG, RentalItem } from '../../data/orvexaData';
import { Solar3DCanvas } from '../3d/Hero3DCanvas';
import { Search, Filter, ArrowRight, ShieldCheck, CheckCircle2, Zap } from 'lucide-react';

interface RentalSectionProps {
  onSelectRentalForQuote: (rentalModel: string) => void;
}

export function RentalSection({ onSelectRentalForQuote }: RentalSectionProps) {
  const [selectedCategory, setSelectedCategory] = useState<string>('TODOS');
  const [searchQuery, setSearchQuery] = useState<string>('');

  const categories = ['TODOS', 'EXCAVADORAS', 'BOBCATS', 'RETROEXCAVADORAS', 'PERFORACIÓN'];

  const filteredItems = RENTAL_CATALOG.filter((item) => {
    const matchesCategory =
      selectedCategory === 'TODOS' || item.category === selectedCategory;
    const matchesQuery =
      item.model.toLowerCase().includes(searchQuery.toLowerCase()) ||
      item.applications.some((app) =>
        app.toLowerCase().includes(searchQuery.toLowerCase())
      );
    return matchesCategory && matchesQuery;
  });

  return (
    <section id="rental" className="relative w-full bg-orvexa-graphite py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-12 gap-6 border-b border-orvexa-darkgray pb-8">
          <div>
            <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase flex items-center gap-2">
              <Zap className="w-4 h-4 text-orvexa-yellow" />
              <span>MARKETPLACE DE ALQUILER DE MAQUINARIA</span>
            </span>
            <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight mt-2">
              NEED EQUIPMENT?
            </h2>
          </div>
          <p className="text-orvexa-lightgray max-w-md text-sm md:text-base leading-relaxed">
            Encuentra la maquinaria adecuada para tu proyecto. Catálogo modular listo para integración con disponibilidad en tiempo real.
          </p>
        </div>

        {/* Filter Bar & Search */}
        <div className="flex flex-col md:flex-row items-stretch md:items-center justify-between gap-4 mb-10 bg-orvexa-black p-4 border border-orvexa-darkgray">
          {/* Category Pills */}
          <div className="flex flex-wrap items-center gap-2">
            <span className="text-xs font-mono text-orvexa-lightgray mr-2 hidden sm:inline flex items-center gap-1">
              <Filter className="w-3.5 h-3.5 text-orvexa-yellow" /> FILTRAR:
            </span>
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`px-4 py-2 text-xs font-display font-bold tracking-wider transition-all duration-300 border ${
                  selectedCategory === cat
                    ? 'bg-orvexa-yellow text-orvexa-black border-orvexa-yellow shadow-[0_0_15px_rgba(245,184,0,0.3)]'
                    : 'bg-orvexa-graphite text-orvexa-lightgray border-orvexa-darkgray hover:text-orvexa-white'
                }`}
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Search Box */}
          <div className="relative min-w-[260px]">
            <input
              type="text"
              placeholder="Buscar por modelo o trabajo..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-orvexa-graphite border border-orvexa-darkgray text-orvexa-white text-xs px-4 py-2.5 pl-10 focus:outline-none focus:border-orvexa-yellow transition-colors placeholder:text-orvexa-lightgray/50"
            />
            <Search className="w-4 h-4 text-orvexa-lightgray absolute left-3 top-3" />
          </div>
        </div>

        {/* Rental Cards Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {filteredItems.map((item) => (
            <div
              key={item.id}
              className="group bg-orvexa-black border border-orvexa-darkgray hover:border-orvexa-yellow/50 transition-all duration-300 flex flex-col justify-between overflow-hidden"
            >
              <div>
                {/* Image & Category Tag */}
                <div className="relative h-44 bg-orvexa-graphite overflow-hidden">
                  <img
                    src={item.image}
                    alt={item.model}
                    className="w-full h-full object-cover opacity-65 group-hover:opacity-90 group-hover:scale-105 transition-all duration-500"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-orvexa-black via-transparent to-transparent" />
                  <span className="absolute top-3 left-3 bg-orvexa-black/90 border border-orvexa-darkgray text-orvexa-yellow font-mono text-[10px] font-bold px-2.5 py-1">
                    {item.category}
                  </span>
                </div>

                {/* Info Container */}
                <div className="p-5 space-y-4">
                  <div>
                    <h3 className="font-display font-bold text-base text-orvexa-white group-hover:text-orvexa-yellow transition-colors">
                      {item.model}
                    </h3>
                    <div className="flex items-center gap-3 text-xs font-mono text-orvexa-lightgray mt-1">
                      <span>{item.power}</span>
                      <span>•</span>
                      <span>{item.operatingWeight}</span>
                    </div>
                  </div>

                  {/* Applications Pills */}
                  <div className="flex flex-wrap gap-1.5 pt-1">
                    {item.applications.map((app, idx) => (
                      <span
                        key={idx}
                        className="bg-orvexa-graphite border border-orvexa-darkgray/60 text-[10px] font-mono text-orvexa-lightgray px-2 py-0.5"
                      >
                        {app}
                      </span>
                    ))}
                  </div>

                  {/* Availability badge */}
                  <div className="flex items-center gap-1.5 text-[11px] font-mono text-emerald-400 pt-2 border-t border-orvexa-darkgray/40">
                    <CheckCircle2 className="w-3.5 h-3.5" />
                    <span>{item.availability}</span>
                  </div>
                </div>
              </div>

              {/* Action Footer */}
              <div className="p-5 pt-0">
                <button
                  onClick={() => onSelectRentalForQuote(item.model)}
                  className="w-full group/btn inline-flex items-center justify-center gap-2 bg-orvexa-graphite hover:bg-orvexa-yellow hover:text-orvexa-black text-orvexa-white font-display font-bold text-xs uppercase tracking-wider py-3 border border-orvexa-darkgray hover:border-orvexa-yellow transition-all duration-300"
                >
                  <span>CONSULTAR →</span>
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

// Dedicated 3D Solar Infrastructure Section
export function SolarSection({ onOpenQuoteModal }: { onOpenQuoteModal: () => void }) {
  return (
    <section id="solar" className="relative w-full bg-orvexa-black py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
          {/* Left Text Column */}
          <div className="lg:col-span-6 space-y-6">
            <div className="inline-flex items-center gap-2 bg-orvexa-graphite border border-orvexa-darkgray text-orvexa-yellow font-mono text-xs px-3.5 py-1.5 uppercase tracking-widest">
              <span>ORVEXA SOLAR SOLUTIONS</span>
            </div>

            <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight leading-tight">
              BUILDING THE <br />
              <span className="text-orvexa-yellow">ENERGY INFRASTRUCTURE.</span>
            </h2>

            <p className="text-orvexa-lightgray text-base leading-relaxed">
              Maquinaria y capacidad operativa para proyectos de infraestructura solar a gran escala.
              Hincado de precisión con guiado GPS, preparación de terrenos y apertura de zanjas.
            </p>

            <div className="grid grid-cols-2 gap-4 pt-4 border-t border-orvexa-darkgray">
              <div>
                <span className="font-display font-bold text-2xl text-orvexa-yellow block">
                  350+
                </span>
                <span className="text-xs font-mono text-orvexa-lightgray">
                  Postes hincados por día por unidad
                </span>
              </div>
              <div>
                <span className="font-display font-bold text-2xl text-orvexa-white block">
                  ±10 mm
                </span>
                <span className="text-xs font-mono text-orvexa-lightgray">
                  Tolerancia de verticalidad GPS
                </span>
              </div>
            </div>

            <div className="pt-4">
              <button
                onClick={onOpenQuoteModal}
                className="group inline-flex items-center gap-3 bg-orvexa-yellow hover:bg-orvexa-brightyellow text-orvexa-black font-display font-bold text-xs uppercase tracking-wider px-8 py-4 transition-all duration-300 shadow-[0_0_25px_rgba(245,184,0,0.3)]"
              >
                <span>CONOCER SOLUCIONES →</span>
              </button>
            </div>
          </div>

          {/* Right 3D Scene Column */}
          <div className="lg:col-span-6 bg-orvexa-graphite border border-orvexa-darkgray relative min-h-[420px] lg:min-h-[500px] overflow-hidden">
            <Solar3DCanvas />
            <div className="absolute bottom-4 left-4 z-10 bg-orvexa-black/80 border border-orvexa-darkgray p-3 backdrop-blur-md">
              <span className="font-mono text-[11px] text-orvexa-yellow font-bold block">
                ESCENA 3D: HINCADORA PV-300 EN PARQUE SOLAR
              </span>
              <span className="text-[10px] text-orvexa-lightgray font-mono">
                Arrastre para rotación libre de la escena
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
