import React, { useState, useEffect } from 'react';
import { ArrowUpRight, Menu, X, ShieldAlert } from 'lucide-react';

interface NavbarProps {
  onOpenQuoteModal: () => void;
  onOpenAdminDrawer: () => void;
}

export function Navbar({ onOpenQuoteModal, onOpenAdminDrawer }: NavbarProps) {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 40) {
        setIsScrolled(true);
      } else {
        setIsScrolled(false);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const navLinks = [
    { name: 'MAQUINARIA', href: '#fleet' },
    { name: 'SERVICIOS', href: '#services' },
    { name: 'ALQUILER', href: '#rental' },
    { name: 'SOLAR', href: '#solar' },
    { name: 'PROYECTOS', href: '#projects' },
    { name: 'NOSOTROS', href: '#standard' },
    { name: 'CONTACTO', href: '#contact' },
  ];

  return (
    <header
      className={`fixed top-0 left-0 w-full z-50 transition-all duration-500 ${
        isScrolled
          ? 'bg-orvexa-black/80 backdrop-blur-md border-b border-orvexa-darkgray/60 py-4 shadow-2xl shadow-black/50'
          : 'bg-transparent py-6 border-b border-transparent'
      }`}
    >
      <div className="max-w-7xl mx-auto px-6 md:px-12 flex items-center justify-between">
        {/* Brand Logo */}
        <a href="#" className="group flex items-center gap-3">
          <div className="w-9 h-9 bg-orvexa-yellow flex items-center justify-center font-display font-black text-orvexa-black text-xl tracking-tighter group-hover:scale-105 transition-transform">
            O
          </div>
          <div className="flex flex-col">
            <span className="font-display font-black text-2xl tracking-tight text-orvexa-white group-hover:text-orvexa-yellow transition-colors">
              ORVEXA
            </span>
            <span className="text-[9px] tracking-[0.25em] text-orvexa-lightgray font-mono uppercase -mt-1">
              HEAVY EQUIPMENT
            </span>
          </div>
        </a>

        {/* Desktop Navigation Menu */}
        <nav className="hidden lg:flex items-center gap-8">
          {navLinks.map((link) => (
            <a
              key={link.name}
              href={link.href}
              className="text-xs font-mono tracking-widest text-orvexa-lightgray hover:text-orvexa-yellow transition-colors relative py-1 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[2px] after:bg-orvexa-yellow hover:after:w-full after:transition-all after:duration-300"
            >
              {link.name}
            </a>
          ))}
        </nav>

        {/* Right CTA Actions */}
        <div className="hidden sm:flex items-center gap-4">
          <button
            onClick={onOpenAdminDrawer}
            title="Panel de Gestión CMS"
            className="p-2 rounded-lg text-orvexa-lightgray hover:text-orvexa-yellow hover:bg-orvexa-darkgray/50 transition-colors"
          >
            <ShieldAlert className="w-4 h-4" />
          </button>

          <button
            onClick={onOpenQuoteModal}
            className="group relative inline-flex items-center gap-2 bg-orvexa-yellow hover:bg-orvexa-brightyellow text-orvexa-black font-display font-bold text-xs uppercase tracking-wider px-6 py-3 rounded-none transition-all duration-300 shadow-[0_0_20px_rgba(245,184,0,0.25)] hover:shadow-[0_0_30px_rgba(255,210,63,0.5)] active:scale-95"
          >
            <span>SOLICITAR COTIZACIÓN</span>
            <ArrowUpRight className="w-4 h-4 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform" />
          </button>
        </div>

        {/* Mobile Hamburger Button */}
        <button
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="lg:hidden p-2 text-orvexa-white hover:text-orvexa-yellow transition-colors"
        >
          {mobileMenuOpen ? <X className="w-7 h-7" /> : <Menu className="w-7 h-7" />}
        </button>
      </div>

      {/* Mobile Drawer Menu */}
      {mobileMenuOpen && (
        <div className="lg:hidden fixed inset-x-0 top-full bg-orvexa-graphite/95 backdrop-blur-xl border-b border-orvexa-darkgray p-6 flex flex-col gap-5 animate-in slide-in-from-top-4 duration-300 shadow-2xl">
          <nav className="flex flex-col gap-4">
            {navLinks.map((link) => (
              <a
                key={link.name}
                href={link.href}
                onClick={() => setMobileMenuOpen(false)}
                className="text-sm font-display font-bold tracking-wider text-orvexa-white hover:text-orvexa-yellow transition-colors py-2 border-b border-orvexa-darkgray/40"
              >
                {link.name}
              </a>
            ))}
          </nav>

          <div className="flex flex-col gap-3 pt-2">
            <button
              onClick={() => {
                setMobileMenuOpen(false);
                onOpenQuoteModal();
              }}
              className="w-full flex items-center justify-center gap-2 bg-orvexa-yellow text-orvexa-black font-display font-bold text-xs uppercase tracking-wider py-3.5"
            >
              <span>SOLICITAR COTIZACIÓN</span>
              <ArrowUpRight className="w-4 h-4" />
            </button>

            <button
              onClick={() => {
                setMobileMenuOpen(false);
                onOpenAdminDrawer();
              }}
              className="w-full text-center text-xs font-mono text-orvexa-lightgray py-2 underline"
            >
              Abrir Panel CMS / Solicitudes
            </button>
          </div>
        </div>
      )}
    </header>
  );
}
