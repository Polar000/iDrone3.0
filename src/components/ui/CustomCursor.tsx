import React, { useEffect, useState } from 'react';

interface CustomCursorProps {
  cursorText?: string;
  cursorMode?: 'default' | 'explore' | 'view' | 'drag';
}

export function CustomCursor({ cursorText = '', cursorMode = 'default' }: CustomCursorProps) {
  const [position, setPosition] = useState({ x: -100, y: -100 });
  const [isHovered, setIsHovered] = useState(false);
  const [isPointerDevice, setIsPointerDevice] = useState(true);

  useEffect(() => {
    // Check if device supports fine pointer (mouse/trackpad)
    const mediaQuery = window.matchMedia('(pointer: fine)');
    setIsPointerDevice(mediaQuery.matches);

    const handlePointerMove = (e: PointerEvent) => {
      setPosition({ x: e.clientX, y: e.clientY });
    };

    window.addEventListener('pointermove', handlePointerMove);
    return () => window.removeEventListener('pointermove', handlePointerMove);
  }, []);

  useEffect(() => {
    setIsHovered(cursorMode !== 'default' || cursorText !== '');
  }, [cursorMode, cursorText]);

  if (!isPointerDevice) return null;

  return (
    <div
      className="fixed top-0 left-0 pointer-events-none z-[9999] transition-transform duration-75 ease-out"
      style={{
        transform: `translate3d(${position.x}px, ${position.y}px, 0)`,
      }}
    >
      {/* Central Cursor Dot */}
      <div
        className={`relative -translate-x-1/2 -translate-y-1/2 rounded-full transition-all duration-300 flex items-center justify-center font-display font-bold tracking-wider text-[10px] ${
          isHovered
            ? 'w-20 h-20 bg-orvexa-yellow text-orvexa-black shadow-[0_0_30px_rgba(245,184,0,0.6)] scale-100'
            : 'w-3 h-3 bg-orvexa-brightyellow shadow-[0_0_10px_#F5B800]'
        }`}
      >
        {isHovered && (
          <span className="uppercase text-center leading-none px-1">
            {cursorText || cursorMode}
          </span>
        )}
      </div>
    </div>
  );
}
