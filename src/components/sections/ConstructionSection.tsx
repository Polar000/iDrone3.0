import React from 'react';
import { Compass, Pickaxe, Ruler, HardHat } from 'lucide-react';

export function ConstructionSection() {
  const steps = [
    {
      num: '01',
      title: 'MOVIMIENTO DE TIERNAS',
      subtitle: 'Desmonte, voladura y gran escala',
      desc: 'Remoción de gran volumen con excavadoras pesadas y camiones articulados. Control topográfico digital.',
      icon: Compass,
    },
    {
      num: '02',
      title: 'EXCAVACIÓN',
      subtitle: 'Cortes profundos y zanjado',
      desc: 'Apertura de zanjas masivas, cimentaciones y nivelación fina con minicargadores y retroexcavadoras.',
      icon: Pickaxe,
    },
    {
      num: '03',
      title: 'PREPARACIÓN',
      subtitle: 'Estabilización y plataformas',
      desc: 'Compactación de alta densidad, pruebas de carga y perfilado láser para soporte estructural.',
      icon: Ruler,
    },
    {
      num: '04',
      title: 'CONSTRUCCIÓN',
      subtitle: 'Infraestructura y entrega',
      desc: 'Ejecución final de obras civiles, vialidades e hincado de estructuras para energías renovables.',
      icon: HardHat,
    },
  ];

  return (
    <section className="relative w-full bg-orvexa-graphite py-28 border-t border-orvexa-darkgray overflow-hidden">
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10">
        {/* Header */}
        <div className="mb-16 border-b border-orvexa-darkgray pb-8">
          <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
            PRESENTACIÓN DE INGENIERÍA
          </span>
          <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight mt-2">
            CONSTRUCTION SEQUENCE
          </h2>
          <p className="text-orvexa-lightgray text-sm md:text-base max-w-xl mt-3">
            Estructura operativa por fases. De la masa de tierra a la infraestructura acabada.
          </p>
        </div>

        {/* 4 Large Number Sequential Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {steps.map((step) => {
            const Icon = step.icon;
            return (
              <div
                key={step.num}
                className="group bg-orvexa-black border border-orvexa-darkgray p-8 flex flex-col justify-between hover:border-orvexa-yellow/60 transition-all duration-300 relative overflow-hidden min-h-[320px]"
              >
                {/* Background Huge Number Outline */}
                <span className="absolute -right-4 -bottom-6 font-display font-black text-8xl text-orvexa-darkgray/30 group-hover:text-orvexa-yellow/10 transition-colors pointer-events-none select-none">
                  {step.num}
                </span>

                <div className="space-y-6 relative z-10">
                  <div className="flex items-center justify-between">
                    <span className="bg-orvexa-yellow text-orvexa-black font-mono font-black text-xs px-3 py-1">
                      {step.num}
                    </span>
                    <Icon className="w-6 h-6 text-orvexa-lightgray group-hover:text-orvexa-yellow transition-colors" />
                  </div>

                  <div>
                    <h3 className="text-xl font-display font-black text-orvexa-white uppercase group-hover:text-orvexa-yellow transition-colors">
                      {step.title}
                    </h3>
                    <p className="text-xs font-mono text-orvexa-yellow mt-1">
                      {step.subtitle}
                    </p>
                  </div>

                  <p className="text-xs text-orvexa-lightgray leading-relaxed">
                    {step.desc}
                  </p>
                </div>

                <div className="pt-6 border-t border-orvexa-darkgray/60 relative z-10">
                  <span className="text-[10px] font-mono text-orvexa-lightgray uppercase tracking-widest group-hover:text-orvexa-white transition-colors">
                    FASE OBRERA • CONTROL EN TIEMPO REAL
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
