import React, { useState } from 'react';
import { SERVICES_DATA, ServiceItem } from '../../data/orvexaData';
import { ArrowUpRight, Check, Plus, Minus, ShieldCheck } from 'lucide-react';

interface ServicesSectionProps {
  onSelectServiceForQuote: (serviceTitle: string) => void;
}

export function ServicesSection({ onSelectServiceForQuote }: ServicesSectionProps) {
  const [expandedId, setExpandedId] = useState<string | null>('heavy-equipment');

  const toggleExpand = (id: string) => {
    setExpandedId(expandedId === id ? null : id);
  };

  return (
    <section id="services" className="relative w-full bg-orvexa-black py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6 border-b border-orvexa-darkgray pb-8">
          <div>
            <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
              CAPACIDADES OPERATIVAS
            </span>
            <h2 className="text-5xl md:text-7xl font-display font-black text-orvexa-white uppercase tracking-tight mt-2">
              WHAT WE DO
            </h2>
          </div>
          <p className="text-orvexa-lightgray max-w-md text-sm md:text-base leading-relaxed">
            Seis líneas especializadas de servicio con ingeniería de precisión y respaldo de maquinaria de alto tonelaje.
          </p>
        </div>

        {/* 6 Interactive Expandable Service Blocks */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {SERVICES_DATA.map((service) => {
            const isExpanded = expandedId === service.id;
            return (
              <div
                key={service.id}
                className={`group relative bg-orvexa-graphite border transition-all duration-500 overflow-hidden flex flex-col justify-between ${
                  isExpanded
                    ? 'border-orvexa-yellow shadow-[0_0_30px_rgba(245,184,0,0.15)] ring-1 ring-orvexa-yellow/50'
                    : 'border-orvexa-darkgray hover:border-orvexa-yellow/40'
                }`}
              >
                {/* Background Image Header */}
                <div className="relative h-48 w-full overflow-hidden bg-orvexa-black">
                  <img
                    src={service.image}
                    alt={service.title}
                    className="w-full h-full object-cover opacity-50 group-hover:opacity-75 group-hover:scale-105 transition-all duration-700"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-orvexa-graphite via-orvexa-graphite/40 to-transparent" />

                  {/* Service Code Number Badge */}
                  <span className="absolute top-4 left-4 bg-orvexa-black/80 border border-orvexa-darkgray text-orvexa-yellow font-mono text-sm font-bold px-3 py-1">
                    {service.code}
                  </span>
                </div>

                {/* Content Area */}
                <div className="p-6 flex-1 flex flex-col justify-between space-y-4">
                  <div>
                    <h3 className="text-xl font-display font-black text-orvexa-white uppercase tracking-wide group-hover:text-orvexa-yellow transition-colors">
                      {service.title}
                    </h3>
                    <p className="text-xs text-orvexa-yellow font-mono mt-1">
                      {service.subtitle}
                    </p>
                    <p className="text-sm text-orvexa-lightgray mt-3 leading-relaxed">
                      {service.shortDesc}
                    </p>
                  </div>

                  {/* Expanded Detail Body */}
                  {isExpanded && (
                    <div className="pt-4 border-t border-orvexa-darkgray space-y-4 animate-in fade-in duration-300">
                      <p className="text-xs text-orvexa-lightgray leading-relaxed">
                        {service.fullDesc}
                      </p>
                      <div className="space-y-2">
                        <span className="text-[11px] font-mono text-orvexa-yellow tracking-wider uppercase font-bold block">
                          PUNTOS CLAVE DE DESPLIEGUE:
                        </span>
                        {service.highlights.map((item, idx) => (
                          <div key={idx} className="flex items-start gap-2 text-xs text-orvexa-white font-sans">
                            <Check className="w-3.5 h-3.5 text-orvexa-yellow shrink-0 mt-0.5" />
                            <span>{item}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Actions Footer */}
                  <div className="pt-4 border-t border-orvexa-darkgray/60 flex items-center justify-between gap-2">
                    <button
                      onClick={() => toggleExpand(service.id)}
                      className="inline-flex items-center gap-2 text-xs font-mono text-orvexa-lightgray hover:text-orvexa-white transition-colors"
                    >
                      {isExpanded ? (
                        <>
                          <Minus className="w-4 h-4 text-orvexa-yellow" />
                          <span>MENOS DETALLES</span>
                        </>
                      ) : (
                        <>
                          <Plus className="w-4 h-4 text-orvexa-yellow" />
                          <span>VER MÁS DETALLES</span>
                        </>
                      )}
                    </button>

                    <button
                      onClick={() => onSelectServiceForQuote(service.title)}
                      className="p-2 bg-orvexa-black border border-orvexa-darkgray hover:bg-orvexa-yellow hover:text-orvexa-black hover:border-orvexa-yellow text-orvexa-yellow transition-all duration-300"
                      title="Solicitar este servicio"
                    >
                      <ArrowUpRight className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
