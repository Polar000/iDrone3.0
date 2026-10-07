import React, { useState } from 'react';
import { FleetShowroomCanvas } from '../3d/Hero3DCanvas';
import { FLEET_DATA, MachineItem } from '../../data/orvexaData';
import {
  Maximize2,
  RotateCw,
  CheckCircle2,
  ArrowRight,
  Gauge,
  Weight,
  Layers,
  Sparkles,
  Info,
} from 'lucide-react';

interface FleetShowroomProps {
  onSelectMachineForQuote: (machine: MachineItem) => void;
  onHover3D?: (isHovering: boolean) => void;
}

export function FleetShowroom({ onSelectMachineForQuote, onHover3D }: FleetShowroomProps) {
  const [selectedMachine, setSelectedMachine] = useState<MachineItem>(FLEET_DATA[0]);

  return (
    <section id="fleet" className="relative w-full bg-orvexa-graphite py-24 border-t border-orvexa-darkgray/60 overflow-hidden">
      {/* Background Subtle Grid Texture */}
      <div className="absolute inset-0 industrial-grid opacity-30 pointer-events-none" />

      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-12 gap-6 border-b border-orvexa-darkgray/60 pb-8">
          <div>
            <div className="inline-flex items-center gap-2 text-orvexa-yellow font-mono text-xs tracking-widest uppercase mb-2">
              <Sparkles className="w-4 h-4" />
              <span>3D INTERACTIVE SHOWROOM</span>
            </div>
            <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight">
              THE FLEET
            </h2>
          </div>
          <p className="text-orvexa-lightgray max-w-md text-sm md:text-base leading-relaxed">
            Equipos preparados para trabajos que no pueden detenerse. Explora nuestra flota en 3D interactivo.
          </p>
        </div>

        {/* Machine Type Selector Tabs */}
        <div className="flex flex-wrap gap-2 md:gap-3 mb-8">
          {FLEET_DATA.map((machine) => {
            const isActive = machine.id === selectedMachine.id;
            return (
              <button
                key={machine.id}
                onClick={() => setSelectedMachine(machine)}
                className={`px-5 py-3 font-display font-bold text-xs uppercase tracking-wider transition-all duration-300 border ${
                  isActive
                    ? 'bg-orvexa-yellow text-orvexa-black border-orvexa-yellow shadow-[0_0_20px_rgba(245,184,0,0.3)]'
                    : 'bg-orvexa-black/60 text-orvexa-lightgray border-orvexa-darkgray hover:border-orvexa-yellow/40 hover:text-orvexa-white'
                }`}
              >
                {machine.category}
              </button>
            );
          })}
        </div>

        {/* Main 3D Showroom + Machine Showcase Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">
          {/* Left / Top: Interactive 3D Canvas Box */}
          <div
            className="lg:col-span-7 bg-orvexa-black border border-orvexa-darkgray relative min-h-[420px] lg:min-h-[580px] flex flex-col justify-between overflow-hidden group"
            onMouseEnter={() => onHover3D?.(true)}
            onMouseLeave={() => onHover3D?.(false)}
          >
            {/* 3D Canvas */}
            <div className="absolute inset-0">
              <FleetShowroomCanvas modelType={selectedMachine.modelType} />
            </div>

            {/* Top Canvas Badges */}
            <div className="relative z-10 p-6 flex items-center justify-between pointer-events-none">
              <span className="bg-orvexa-black/80 border border-orvexa-darkgray text-orvexa-yellow font-mono text-xs font-bold px-3 py-1.5 backdrop-blur-md">
                {selectedMachine.code}
              </span>
              <div className="flex items-center gap-2 bg-orvexa-black/80 border border-orvexa-darkgray text-orvexa-lightgray font-mono text-[11px] px-3 py-1.5 backdrop-blur-md">
                <RotateCw className="w-3.5 h-3.5 text-orvexa-yellow animate-spin" style={{ animationDuration: '8s' }} />
                <span>360° INTERACTIVO (ARRASTRA PARA ROTAR)</span>
              </div>
            </div>

            {/* Bottom Canvas Instructions */}
            <div className="relative z-10 p-6 pointer-events-none flex items-center justify-between bg-gradient-to-t from-orvexa-black via-orvexa-black/60 to-transparent">
              <div>
                <h3 className="font-display font-black text-2xl text-orvexa-white">
                  {selectedMachine.name}
                </h3>
                <p className="text-xs text-orvexa-lightgray font-mono">
                  MODELO: {selectedMachine.model}
                </p>
              </div>
              <div className="flex items-center gap-2 text-xs font-mono text-orvexa-yellow">
                <Maximize2 className="w-4 h-4" />
                <span className="hidden sm:inline">ZOOM HABILITADO</span>
              </div>
            </div>
          </div>

          {/* Right / Bottom: Specifications & Specs Detail Panel */}
          <div className="lg:col-span-5 bg-orvexa-black/60 border border-orvexa-darkgray p-8 flex flex-col justify-between space-y-6">
            <div className="space-y-6">
              {/* Header Title & Availability Status */}
              <div>
                <div className="inline-flex items-center gap-2 text-emerald-400 font-mono text-xs font-semibold mb-2">
                  <CheckCircle2 className="w-4 h-4" />
                  <span>{selectedMachine.availabilityText}</span>
                </div>
                <h3 className="text-2xl font-display font-bold text-orvexa-white">
                  {selectedMachine.name}
                </h3>
                <p className="text-sm text-orvexa-lightgray mt-2 leading-relaxed">
                  {selectedMachine.description}
                </p>
              </div>

              {/* Quick Spec Highlights Badges */}
              <div className="grid grid-cols-2 gap-3 pt-2">
                <div className="bg-orvexa-graphite border border-orvexa-darkgray p-3.5">
                  <div className="flex items-center gap-2 text-orvexa-yellow text-xs font-mono mb-1">
                    <Gauge className="w-4 h-4" />
                    <span>POTENCIA</span>
                  </div>
                  <span className="font-display font-bold text-orvexa-white text-sm">
                    {selectedMachine.power}
                  </span>
                </div>

                <div className="bg-orvexa-graphite border border-orvexa-darkgray p-3.5">
                  <div className="flex items-center gap-2 text-orvexa-yellow text-xs font-mono mb-1">
                    <Weight className="w-4 h-4" />
                    <span>PESO / CAPACIDAD</span>
                  </div>
                  <span className="font-display font-bold text-orvexa-white text-sm">
                    {selectedMachine.weight}
                  </span>
                </div>
              </div>

              {/* Detailed Specs List */}
              <div className="space-y-3 pt-2 border-t border-orvexa-darkgray/60">
                <h4 className="text-xs font-mono tracking-widest text-orvexa-lightgray uppercase flex items-center gap-2">
                  <Info className="w-4 h-4 text-orvexa-yellow" />
                  <span>ESPECIFICACIONES TÉCNICAS</span>
                </h4>
                <div className="space-y-2">
                  {selectedMachine.specs.map((spec, i) => (
                    <div
                      key={i}
                      className="flex items-center justify-between text-xs py-1.5 border-b border-orvexa-darkgray/40 font-mono"
                    >
                      <span className="text-orvexa-lightgray">{spec.label}</span>
                      <span className="text-orvexa-white font-bold">{spec.value}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Applications */}
              <div className="space-y-2 pt-2">
                <h4 className="text-xs font-mono tracking-widest text-orvexa-lightgray uppercase">
                  APLICACIONES PRINCIPALES:
                </h4>
                <ul className="space-y-1.5">
                  {selectedMachine.applications.map((app, i) => (
                    <li key={i} className="flex items-start gap-2 text-xs text-orvexa-lightgray">
                      <span className="text-orvexa-yellow mt-0.5">•</span>
                      <span>{app}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            {/* Action CTA */}
            <div className="pt-6 border-t border-orvexa-darkgray">
              <button
                onClick={() => onSelectMachineForQuote(selectedMachine)}
                className="w-full group inline-flex items-center justify-center gap-3 bg-orvexa-yellow hover:bg-orvexa-brightyellow text-orvexa-black font-display font-bold text-xs uppercase tracking-wider py-4 transition-all duration-300 shadow-[0_0_20px_rgba(245,184,0,0.25)] hover:shadow-[0_0_30px_rgba(255,210,63,0.5)]"
              >
                <span>SOLICITAR INFORMACIÓN →</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

// "ORVEXA WORLD" Multi-Zone Interactive Site Showcase Section
export function OrvexaWorldSection() {
  const [activeZone, setActiveZone] = useState(0);

  const zones = [
    {
      id: 'z-solar',
      title: 'ZONA 01: INFRAESTRUCTURA SOLAR',
      desc: 'Adecuación topográfica e hincado automatizado con guiado GPS para parques fotovoltaicos masivos.',
      metric: 'Hasta 350 postes hincados por jornada diaria',
      image: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80',
    },
    {
      id: 'z-earth',
      title: 'ZONA 02: MOVIMIENTO DE TIERRAS & EXCAVACIÓN',
      desc: 'Corte masivo en terreno rocoso, nivelación volumétrica y preparación de plataformas industriales.',
      metric: 'Capacidad de remoción de 15,000+ m³ / día',
      image: 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=1200&q=80',
    },
    {
      id: 'z-drill',
      title: 'ZONA 03: PERFORACIÓN PROFUNDA & PILOTAJE',
      desc: 'Cimentación para puentes, naves pesadas e infraestructura con torres de alto torque.',
      metric: 'Profundidades de perforación hasta 50 metros',
      image: 'https://images.unsplash.com/photo-1513828583688-c52646db42da?auto=format&fit=crop&w=1200&q=80',
    },
    {
      id: 'z-const',
      title: 'ZONA 04: OBRAS CIVILES & VÍAS DE CARGA',
      desc: 'Construcción de corredores logísticos, accesos a obra y obras de arte mayor.',
      metric: 'Pavimentación y compactación de alta densidad',
      image: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?auto=format&fit=crop&w=1200&q=80',
    },
  ];

  return (
    <section className="relative w-full bg-orvexa-black py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        <div className="mb-12">
          <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
            ORVEXA WORLD / SITE CAPABILITIES
          </span>
          <h2 className="text-5xl md:text-7xl font-display font-black text-orvexa-white uppercase tracking-tight mt-2">
            BUILT FOR SCALE.
          </h2>
          <p className="text-orvexa-lightgray text-base max-w-xl mt-4">
            Un ecosistema de maquinaria e ingeniería adaptado a cada fase del proyecto.
          </p>
        </div>

        {/* Zone Navigation Pills */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {zones.map((zone, idx) => (
            <button
              key={zone.id}
              onClick={() => setActiveZone(idx)}
              className={`p-6 text-left border transition-all duration-300 flex flex-col justify-between min-h-[140px] ${
                activeZone === idx
                  ? 'bg-orvexa-graphite border-orvexa-yellow shadow-[0_0_25px_rgba(245,184,0,0.2)]'
                  : 'bg-orvexa-graphite/40 border-orvexa-darkgray hover:border-orvexa-yellow/50'
              }`}
            >
              <span
                className={`font-mono text-xs font-bold ${
                  activeZone === idx ? 'text-orvexa-yellow' : 'text-orvexa-lightgray'
                }`}
              >
                0{idx + 1}
              </span>
              <h3 className="font-display font-bold text-sm text-orvexa-white uppercase tracking-wide">
                {zone.title.split(': ')[1]}
              </h3>
            </button>
          ))}
        </div>

        {/* Active Zone Interactive Visual Display */}
        <div className="relative bg-orvexa-graphite border border-orvexa-darkgray overflow-hidden min-h-[420px] md:min-h-[520px] flex items-end">
          <img
            src={zones[activeZone].image}
            alt={zones[activeZone].title}
            className="absolute inset-0 w-full h-full object-cover opacity-45 mix-blend-luminosity scale-105 transition-all duration-700 hover:scale-100"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-orvexa-black via-orvexa-black/60 to-transparent" />

          {/* Floating Zone Detail Cards */}
          <div className="relative z-10 p-8 md:p-12 max-w-2xl space-y-4">
            <span className="bg-orvexa-yellow text-orvexa-black font-mono font-bold text-xs uppercase px-3 py-1">
              {zones[activeZone].title}
            </span>
            <p className="text-xl md:text-2xl font-display font-semibold text-orvexa-white leading-snug">
              {zones[activeZone].desc}
            </p>
            <div className="inline-flex items-center gap-3 bg-orvexa-black/80 border border-orvexa-darkgray px-4 py-2 text-xs font-mono text-orvexa-yellow">
              <Layers className="w-4 h-4" />
              <span>{zones[activeZone].metric}</span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
