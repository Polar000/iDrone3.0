import React, { useState } from 'react';
import { CustomCursor } from './components/ui/CustomCursor';
import { Navbar } from './components/layout/Navbar';
import { HeroSection } from './components/sections/HeroSection';
import { FleetShowroom, OrvexaWorldSection } from './components/sections/FleetShowroom';
import { ServicesSection } from './components/sections/ServicesSection';
import { RentalSection, SolarSection } from './components/sections/RentalSection';
import { ConstructionSection } from './components/sections/ConstructionSection';
import { ProjectsSection, OrvexaStandardSection } from './components/sections/ProjectsSection';
import { ContactSection } from './components/sections/ContactSection';
import { AdminDrawer } from './components/admin/AdminDrawer';
import { MachineItem } from './data/orvexaData';

export default function App() {
  const [cursorText, setCursorText] = useState('');
  const [cursorMode, setCursorMode] = useState<'default' | 'explore' | 'view' | 'drag'>('default');
  const [quoteMachineOrService, setQuoteMachineOrService] = useState('');
  const [isAdminOpen, setIsAdminOpen] = useState(false);

  const handleSelectMachineForQuote = (machine: MachineItem) => {
    setQuoteMachineOrService(`${machine.category} / ${machine.name}`);
    const contactElement = document.getElementById('contact');
    if (contactElement) {
      contactElement.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleSelectServiceForQuote = (serviceTitle: string) => {
    setQuoteMachineOrService(`SERVICIO: ${serviceTitle}`);
    const contactElement = document.getElementById('contact');
    if (contactElement) {
      contactElement.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleSelectRentalForQuote = (rentalModel: string) => {
    setQuoteMachineOrService(`ALQUILER: ${rentalModel}`);
    const contactElement = document.getElementById('contact');
    if (contactElement) {
      contactElement.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div className="relative min-h-screen bg-orvexa-black text-orvexa-white font-sans overflow-x-hidden selection:bg-orvexa-yellow selection:text-orvexa-black">
      {/* Custom Desktop Cursor */}
      <CustomCursor cursorText={cursorText} cursorMode={cursorMode} />

      {/* Glassmorphic Navbar */}
      <Navbar
        onOpenQuoteModal={() => {
          const contactElement = document.getElementById('contact');
          contactElement?.scrollIntoView({ behavior: 'smooth' });
        }}
        onOpenAdminDrawer={() => setIsAdminOpen(true)}
      />

      {/* Main Page Flow */}
      <main className="relative z-10 space-y-0">
        {/* 1. Hero 3D Experience */}
        <HeroSection
          onOpenQuoteModal={() => {
            const contactElement = document.getElementById('contact');
            contactElement?.scrollIntoView({ behavior: 'smooth' });
          }}
          onHover3D={(isHovering) => {
            if (isHovering) {
              setCursorMode('drag');
              setCursorText('3D PARALLAX');
            } else {
              setCursorMode('default');
              setCursorText('');
            }
          }}
        />

        {/* 2. 3D Fleet Showroom */}
        <FleetShowroom
          onSelectMachineForQuote={handleSelectMachineForQuote}
          onHover3D={(isHovering) => {
            if (isHovering) {
              setCursorMode('explore');
              setCursorText('360° ROTATE');
            } else {
              setCursorMode('default');
              setCursorText('');
            }
          }}
        />

        {/* 3. ORVEXA WORLD Zone Explorer */}
        <OrvexaWorldSection />

        {/* 4. Services ("WHAT WE DO") */}
        <ServicesSection onSelectServiceForQuote={handleSelectServiceForQuote} />

        {/* 5. Rental Marketplace ("NEED EQUIPMENT?") */}
        <RentalSection onSelectRentalForQuote={handleSelectRentalForQuote} />

        {/* 6. Solar Infrastructure */}
        <SolarSection
          onOpenQuoteModal={() => {
            setQuoteMachineOrService('EQUIPO SOLAR PV-300 / INFRAESTRUCTURA');
            const contactElement = document.getElementById('contact');
            contactElement?.scrollIntoView({ behavior: 'smooth' });
          }}
        />

        {/* 7. Construction Sequence (01-04) */}
        <ConstructionSection />

        {/* 8. Horizontal Projects Gallery */}
        <ProjectsSection />

        {/* 9. The ORVEXA Standard */}
        <OrvexaStandardSection />

        {/* 10. 3D Finale & Contact Form */}
        <ContactSection
          initialMachineOrService={quoteMachineOrService}
          onHover3D={(isHovering) => {
            if (isHovering) {
              setCursorMode('view');
              setCursorText('SPOTLIGHT');
            } else {
              setCursorMode('default');
              setCursorText('');
            }
          }}
        />
      </main>

      {/* CMS / Admin Quotes Drawer Modal */}
      <AdminDrawer isOpen={isAdminOpen} onClose={() => setIsAdminOpen(false)} />

      {/* Footer */}
      <footer className="bg-orvexa-graphite border-t border-orvexa-darkgray py-12 px-6 md:px-12 relative z-10">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-orvexa-yellow text-orvexa-black font-display font-black flex items-center justify-center text-lg">
              O
            </div>
            <div>
              <span className="font-display font-bold text-xl text-orvexa-white tracking-tight">
                ORVEXA
              </span>
              <p className="text-[10px] font-mono text-orvexa-lightgray tracking-widest uppercase">
                THE POWER BEHIND THE PROJECT
              </p>
            </div>
          </div>

          <p className="text-xs font-mono text-orvexa-lightgray text-center">
            © {new Date().getFullYear()} ORVEXA HEAVY EQUIPMENT & INFRASTRUCTURE S.A. TODOS LOS DERECHOS RESERVADOS.
          </p>

          <button
            onClick={() => setIsAdminOpen(true)}
            className="text-xs font-mono text-orvexa-yellow hover:underline"
          >
            PANEL ADMINISTRATIVO CMS ↗
          </button>
        </div>
      </footer>
    </div>
  );
}
