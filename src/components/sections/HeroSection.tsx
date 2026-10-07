import React, { useState, useEffect } from 'react';
import Hero3DCanvas from '../3d/Hero3DCanvas';
import { ArrowRight, ChevronDown, Activity, Sparkles } from 'lucide-react';

interface HeroSectionProps {
  onOpenQuoteModal: () => void;
  onHover3D?: (isHovering: boolean) => void;
}

export function HeroSection({ onOpenQuoteModal, onHover3D }: HeroSectionProps) {
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      const { innerWidth, innerHeight } = window;
      const x = (e.clientX / innerWidth) * 2 - 1;
      const y = -(e.clientY / innerHeight) * 2 + 1;
      setMousePos({ x, y });
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  return (
    <section className="relative w-full min-h-screen bg-orvexa-black flex flex-col justify-between overflow-hidden pt-28 pb-12">
      {/* Background 3D WebGL Scene */}
      <div
        className="absolute inset-0 z-0 opacity-90 transition-opacity duration-1000"
        onMouseEnter={() => onHover3D?.(true)}
        onMouseLeave={() => onHover3D?.(false)}
      >
        <Hero3DCanvas mousePos={mousePos} />
      </div>

      {/* Industrial Vignette Gradient Overlays */}
      <div className="absolute inset-0 z-10 pointer-events-none bg-gradient-to-t from-orvexa-black via-transparent to-orvexa-black/60" />
      <div className="absolute inset-0 z-10 pointer-events-none bg-radial-gradient from-transparent via-orvexa-black/30 to-orvexa-black" />

      {/* Hero Typography & Hero Text Overlay */}
      <div className="relative z-20 max-w-7xl mx-auto px-6 md:px-12 my-auto w-full">
        <div className="max-w-3xl space-y-6">
          {/* Badge Tag */}
          <div className="inline-flex items-center gap-3 bg-orvexa-graphite/80 border border-orvexa-darkgray px-4 py-2 rounded-none backdrop-blur-md">
            <span className="flex h-2 w-2 relative">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-orvexa-brightyellow opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-orvexa-yellow"></span>
            </span>
            <span className="text-[11px] font-mono tracking-[0.2em] text-orvexa-lightgray uppercase">
              ORVEXA / HEAVY EQUIPMENT
            </span>
          </div>

          {/* Giant Title */}
          <h1 className="text-5xl sm:text-7xl md:text-8xl font-display font-black text-orvexa-white uppercase tracking-tight leading-[0.92] drop-shadow-2xl">
            MOVEMOS <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-orvexa-white via-orvexa-white to-orvexa-yellow">
              LO QUE
            </span>{' '}
            <br />
            <span className="text-orvexa-yellow">IMPORTA.</span>
          </h1>

          {/* Subtext */}
          <p className="text-base sm:text-lg md:text-xl text-orvexa-lightgray font-sans font-normal max-w-xl leading-relaxed">
            Maquinaria, infraestructura y soluciones avanzadas para proyectos
            que exigen máxima capacidad operacional.
          </p>

          {/* Action Buttons */}
          <div className="pt-4 flex flex-wrap items-center gap-4">
            <a
              href="#fleet"
              className="group inline-flex items-center gap-3 bg-orvexa-yellow hover:bg-orvexa-brightyellow text-orvexa-black font-display font-bold text-sm uppercase tracking-wider px-8 py-4 transition-all duration-300 shadow-[0_0_30px_rgba(245,184,0,0.3)] hover:shadow-[0_0_40px_rgba(255,210,63,0.6)] active:scale-95"
            >
              <span>EXPLORAR MAQUINARIA</span>
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1.5 transition-transform" />
            </a>

            <button
              onClick={onOpenQuoteModal}
              className="inline-flex items-center gap-2 bg-orvexa-graphite/80 hover:bg-orvexa-darkgray text-orvexa-white font-display font-bold text-sm uppercase tracking-wider px-8 py-4 border border-orvexa-darkgray hover:border-orvexa-yellow/50 backdrop-blur-md transition-all duration-300 active:scale-95"
            >
              <span>SOLICITAR COTIZACIÓN</span>
            </button>
          </div>
        </div>
      </div>

      {/* Hero Bottom Bar Indicator */}
      <div className="relative z-20 max-w-7xl mx-auto px-6 md:px-12 w-full pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-orvexa-darkgray/40">
        <div className="flex items-center gap-6 text-xs font-mono text-orvexa-lightgray uppercase tracking-widest">
          <div className="flex items-center gap-2">
            <Activity className="w-4 h-4 text-orvexa-yellow animate-pulse" />
            <span>THE POWER BEHIND THE PROJECT</span>
          </div>
          <span className="hidden md:inline text-orvexa-darkgray">|</span>
          <span className="hidden md:inline">CAPACIDAD · PRECISIÓN · ESCALA</span>
        </div>

        <a
          href="#fleet"
          className="group flex items-center gap-2 text-xs font-mono text-orvexa-lightgray hover:text-orvexa-yellow tracking-widest uppercase transition-colors"
        >
          <span>SCROLL TO EXPLORE</span>
          <ChevronDown className="w-4 h-4 text-orvexa-yellow group-hover:translate-y-1 transition-transform" />
        </a>
      </div>
    </section>
  );
}
