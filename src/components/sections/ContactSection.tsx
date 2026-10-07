import React, { useState } from 'react';
import { Finale3DCanvas } from '../3d/Hero3DCanvas';
import { saveQuoteRequest } from '../../data/orvexaData';
import confetti from 'canvas-confetti';
import {
  Send,
  CheckCircle2,
  Phone,
  Mail,
  MapPin,
  Building,
  User,
  MessageSquare,
  Sparkles,
} from 'lucide-react';

interface ContactSectionProps {
  initialMachineOrService?: string;
  onHover3D?: (isHovering: boolean) => void;
}

export function ContactSection({ initialMachineOrService = '', onHover3D }: ContactSectionProps) {
  const [formData, setFormData] = useState({
    name: '',
    company: '',
    phone: '',
    email: '',
    location: '',
    projectType: 'Parque Solar / Renovables',
    machineOrService: initialMachineOrService || 'EXCAVADORA ORVEXA X-500',
    message: '',
  });

  const [submitted, setSubmitted] = useState(false);
  const [submittedQuoteId, setSubmittedQuoteId] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name || !formData.email || !formData.phone) return;

    const saved = saveQuoteRequest(formData);
    setSubmittedQuoteId(saved.id);
    setSubmitted(true);

    try {
      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.6 },
        colors: ['#F5B800', '#FFD23F', '#FFFFFF'],
      });
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <section id="contact" className="relative w-full bg-orvexa-black py-28 border-t border-orvexa-darkgray overflow-hidden">
      {/* 3D Spotlight Scene Background Header */}
      <div className="max-w-7xl mx-auto px-6 md:px-12 relative z-10 mb-16">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center bg-orvexa-graphite border border-orvexa-darkgray overflow-hidden">
          {/* Text Callout */}
          <div className="lg:col-span-6 p-8 md:p-12 space-y-4">
            <span className="text-orvexa-yellow font-mono text-xs tracking-widest uppercase">
              FINAL 3D EXPERIENCE / LET'S WORK
            </span>
            <h2 className="text-4xl md:text-6xl font-display font-black text-orvexa-white uppercase tracking-tight">
              HAVE A PROJECT <br />
              <span className="text-orvexa-yellow">IN MIND?</span>
            </h2>
            <p className="text-orvexa-lightgray text-base font-sans">
              Pongamos la maquinaria a trabajar. Envíanos los parámetros de tu proyecto para una respuesta prioritaria.
            </p>
          </div>

          {/* Dramatic 3D Machine Spotlight Box */}
          <div
            className="lg:col-span-6 h-[300px] lg:h-[380px] bg-orvexa-black relative border-t lg:border-t-0 lg:border-l border-orvexa-darkgray"
            onMouseEnter={() => onHover3D?.(true)}
            onMouseLeave={() => onHover3D?.(false)}
          >
            <Finale3DCanvas />
            <div className="absolute top-4 right-4 bg-orvexa-black/80 border border-orvexa-darkgray px-3 py-1 text-[10px] font-mono text-orvexa-yellow">
              ESTADO FLOTA: LISTO
            </div>
          </div>
        </div>
      </div>

      {/* Industrial Contact Panel Form */}
      <div className="max-w-4xl mx-auto px-6 relative z-10">
        <div className="bg-orvexa-graphite border border-orvexa-darkgray p-8 md:p-12 relative shadow-2xl">
          <div className="border-b border-orvexa-darkgray pb-6 mb-8 flex items-center justify-between">
            <h3 className="font-display font-black text-2xl text-orvexa-white uppercase flex items-center gap-3">
              <Sparkles className="w-5 h-5 text-orvexa-yellow" />
              <span>PANEL DE SOLICITUD DE COTIZACIÓN</span>
            </h3>
            <span className="font-mono text-xs text-orvexa-yellow">
              TIEMPO DE RESPUESTA &lt; 24H
            </span>
          </div>

          {submitted ? (
            <div className="py-12 text-center space-y-6 animate-in zoom-in-95 duration-300">
              <div className="w-16 h-16 bg-orvexa-yellow text-orvexa-black mx-auto flex items-center justify-center rounded-full">
                <CheckCircle2 className="w-10 h-10" />
              </div>
              <h4 className="text-3xl font-display font-black text-orvexa-white">
                SOLICITUD REGISTRADA EXITOSAMENTE
              </h4>
              <p className="text-orvexa-lightgray text-sm max-w-md mx-auto">
                Código de seguimiento:{' '}
                <span className="text-orvexa-yellow font-mono font-bold">
                  {submittedQuoteId}
                </span>
                . Nuestro equipo de operaciones técnicas se pondrá en contacto en breve.
              </p>
              <button
                onClick={() => {
                  setSubmitted(false);
                  setFormData({
                    name: '',
                    company: '',
                    phone: '',
                    email: '',
                    location: '',
                    projectType: 'Parque Solar / Renovables',
                    machineOrService: '',
                    message: '',
                  });
                }}
                className="bg-orvexa-black hover:bg-orvexa-darkgray text-orvexa-yellow font-display font-bold text-xs uppercase tracking-wider px-6 py-3 border border-orvexa-yellow transition-colors"
              >
                ENVIAR OTRA SOLICITUD
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Name */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                    <User className="w-3.5 h-3.5 text-orvexa-yellow" />
                    <span>NOMBRE COMPLETO *</span>
                  </label>
                  <input
                    type="text"
                    required
                    placeholder="Ej. Ing. Roberto Gómez"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  />
                </div>

                {/* Company */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                    <Building className="w-3.5 h-3.5 text-orvexa-yellow" />
                    <span>EMPRESA / ORGANIZACIÓN</span>
                  </label>
                  <input
                    type="text"
                    placeholder="Ej. Infraestructura S.A."
                    value={formData.company}
                    onChange={(e) => setFormData({ ...formData, company: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  />
                </div>

                {/* Phone */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                    <Phone className="w-3.5 h-3.5 text-orvexa-yellow" />
                    <span>TELÉFONO DE CONTACTO *</span>
                  </label>
                  <input
                    type="tel"
                    required
                    placeholder="+52 / +57 / +502 ..."
                    value={formData.phone}
                    onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  />
                </div>

                {/* Email */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                    <Mail className="w-3.5 h-3.5 text-orvexa-yellow" />
                    <span>CORREO ELECTRÓNICO *</span>
                  </label>
                  <input
                    type="email"
                    required
                    placeholder="correo@empresa.com"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  />
                </div>

                {/* Location */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                    <MapPin className="w-3.5 h-3.5 text-orvexa-yellow" />
                    <span>UBICACIÓN DEL PROYECTO</span>
                  </label>
                  <input
                    type="text"
                    placeholder="Ciudad / Estado / Región"
                    value={formData.location}
                    onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  />
                </div>

                {/* Project Type */}
                <div className="space-y-2">
                  <label className="text-xs font-mono text-orvexa-lightgray uppercase">
                    TIPO DE PROYECTO
                  </label>
                  <select
                    value={formData.projectType}
                    onChange={(e) => setFormData({ ...formData, projectType: e.target.value })}
                    className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                  >
                    <option value="Parque Solar / Renovables">Parque Solar / Renovables</option>
                    <option value="Movimiento de Tierras Masivo">Movimiento de Tierras Masivo</option>
                    <option value="Perforación & Cimentación Profunda">Perforación & Cimentación Profunda</option>
                    <option value="Infraestructura Vial & Carreteras">Infraestructura Vial & Carreteras</option>
                    <option value="Alquiler de Flota Específica">Alquiler de Flota Específica</option>
                  </select>
                </div>
              </div>

              {/* Machine or Service */}
              <div className="space-y-2">
                <label className="text-xs font-mono text-orvexa-lightgray uppercase">
                  MAQUINARIA O SERVICIO DE INTERÉS
                </label>
                <input
                  type="text"
                  placeholder="Ej. Excavadora X-500, Perforadora D-800, Hincado Solar..."
                  value={formData.machineOrService}
                  onChange={(e) => setFormData({ ...formData, machineOrService: e.target.value })}
                  className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm px-4 py-3.5 focus:outline-none focus:border-orvexa-yellow transition-colors"
                />
              </div>

              {/* Message */}
              <div className="space-y-2">
                <label className="text-xs font-mono text-orvexa-lightgray uppercase flex items-center gap-2">
                  <MessageSquare className="w-3.5 h-3.5 text-orvexa-yellow" />
                  <span>DETALLES DEL PROYECTO & REQUERIMIENTOS</span>
                </label>
                <textarea
                  rows={4}
                  placeholder="Describe el volumen de trabajo, plazos estipulados y requerimientos específicos..."
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  className="w-full bg-orvexa-black border border-orvexa-darkgray text-orvexa-white text-sm p-4 focus:outline-none focus:border-orvexa-yellow transition-colors resize-none"
                />
              </div>

              {/* Submit CTA */}
              <button
                type="submit"
                className="w-full group inline-flex items-center justify-center gap-3 bg-orvexa-yellow hover:bg-orvexa-brightyellow text-orvexa-black font-display font-black text-sm uppercase tracking-wider py-4 transition-all duration-300 shadow-[0_0_25px_rgba(245,184,0,0.3)] hover:shadow-[0_0_35px_rgba(255,210,63,0.6)]"
              >
                <span>ENVIAR SOLICITUD DE COTIZACIÓN</span>
                <Send className="w-4 h-4 group-hover:translate-x-1.5 transition-transform" />
              </button>
            </form>
          )}
        </div>
      </div>
    </section>
  );
}
