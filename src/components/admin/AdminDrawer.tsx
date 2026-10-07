import React, { useState, useEffect } from 'react';
import { getQuoteRequests, QuoteRequest } from '../../data/orvexaData';
import {
  X,
  ShieldCheck,
  RefreshCw,
  Clock,
  CheckCircle,
  FileText,
  Building,
  User,
  Phone,
  Mail,
  MapPin,
  MessageSquare,
} from 'lucide-react';

interface AdminDrawerProps {
  isOpen: boolean;
  onClose: () => void;
}

export function AdminDrawer({ isOpen, onClose }: AdminDrawerProps) {
  const [quotes, setQuotes] = useState<QuoteRequest[]>([]);
  const [filterStatus, setFilterStatus] = useState<string>('ALL');

  const reloadQuotes = () => {
    setQuotes(getQuoteRequests());
  };

  useEffect(() => {
    if (isOpen) {
      reloadQuotes();
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const filteredQuotes = quotes.filter((q) => {
    if (filterStatus === 'ALL') return true;
    return q.status === filterStatus;
  });

  return (
    <div className="fixed inset-0 z-[120] bg-orvexa-black/80 backdrop-blur-md flex justify-end animate-in fade-in duration-200">
      <div className="w-full max-w-2xl bg-orvexa-graphite border-l border-orvexa-darkgray h-full overflow-y-auto p-6 md:p-8 flex flex-col justify-between shadow-2xl">
        <div className="space-y-6">
          {/* Header */}
          <div className="flex items-center justify-between border-b border-orvexa-darkgray pb-6">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 bg-orvexa-yellow text-orvexa-black flex items-center justify-center font-bold">
                <ShieldCheck className="w-5 h-5" />
              </div>
              <div>
                <h3 className="font-display font-black text-xl text-orvexa-white">
                  PANEL CMS / SOLICITUDES DE COTIZACIÓN
                </h3>
                <span className="text-xs font-mono text-orvexa-yellow">
                  ORVEXA ADMINISTRATIVE SYSTEM
                </span>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={reloadQuotes}
                className="p-2 bg-orvexa-black text-orvexa-lightgray hover:text-orvexa-yellow border border-orvexa-darkgray"
                title="Recargar datos"
              >
                <RefreshCw className="w-4 h-4" />
              </button>
              <button
                onClick={onClose}
                className="p-2 bg-orvexa-black text-orvexa-lightgray hover:text-orvexa-white border border-orvexa-darkgray"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
          </div>

          {/* Filter Pills */}
          <div className="flex items-center gap-2 border-b border-orvexa-darkgray pb-4">
            <span className="text-xs font-mono text-orvexa-lightgray">ESTADO:</span>
            {['ALL', 'PENDING', 'IN_REVIEW'].map((status) => (
              <button
                key={status}
                onClick={() => setFilterStatus(status)}
                className={`px-3 py-1 text-[11px] font-mono border ${
                  filterStatus === status
                    ? 'bg-orvexa-yellow text-orvexa-black border-orvexa-yellow font-bold'
                    : 'bg-orvexa-black text-orvexa-lightgray border-orvexa-darkgray hover:text-orvexa-white'
                }`}
              >
                {status === 'ALL'
                  ? 'TODOS'
                  : status === 'PENDING'
                  ? 'PENDIENTE'
                  : 'EN REVISIÓN'}
              </button>
            ))}
          </div>

          {/* Quotes List */}
          <div className="space-y-4">
            {filteredQuotes.length === 0 ? (
              <div className="p-8 text-center text-xs font-mono text-orvexa-lightgray border border-orvexa-darkgray">
                No hay solicitudes registradas con este filtro.
              </div>
            ) : (
              filteredQuotes.map((quote) => (
                <div
                  key={quote.id}
                  className="bg-orvexa-black border border-orvexa-darkgray p-5 space-y-3 hover:border-orvexa-yellow/50 transition-colors"
                >
                  <div className="flex items-center justify-between border-b border-orvexa-darkgray/60 pb-2">
                    <span className="font-mono text-xs font-bold text-orvexa-yellow">
                      {quote.id}
                    </span>
                    <span className="text-[10px] font-mono text-orvexa-lightgray">
                      {quote.createdAt}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-2 text-xs font-sans">
                    <div className="flex items-center gap-2 text-orvexa-white">
                      <User className="w-3.5 h-3.5 text-orvexa-yellow shrink-0" />
                      <span className="font-semibold">{quote.name}</span>
                    </div>
                    <div className="flex items-center gap-2 text-orvexa-lightgray">
                      <Building className="w-3.5 h-3.5 text-orvexa-yellow shrink-0" />
                      <span>{quote.company || 'Particular'}</span>
                    </div>
                    <div className="flex items-center gap-2 text-orvexa-lightgray">
                      <Phone className="w-3.5 h-3.5 text-orvexa-yellow shrink-0" />
                      <span>{quote.phone}</span>
                    </div>
                    <div className="flex items-center gap-2 text-orvexa-lightgray">
                      <Mail className="w-3.5 h-3.5 text-orvexa-yellow shrink-0" />
                      <span className="truncate">{quote.email}</span>
                    </div>
                  </div>

                  <div className="bg-orvexa-graphite p-3 border border-orvexa-darkgray/60 text-xs space-y-1">
                    <span className="text-[10px] font-mono text-orvexa-yellow block">
                      REQUERIMIENTO:
                    </span>
                    <p className="text-orvexa-white font-mono">{quote.machineOrService}</p>
                    <p className="text-orvexa-lightgray text-[11px]">{quote.message}</p>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="pt-6 border-t border-orvexa-darkgray text-[11px] font-mono text-orvexa-lightgray flex items-center justify-between">
          <span>SISTEMA DE GESTIÓN ORVEXA © 2025</span>
          <span className="text-orvexa-yellow">OPERACIONAL</span>
        </div>
      </div>
    </div>
  );
}
