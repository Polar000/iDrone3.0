import React, { Suspense, useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { OrbitControls, PerspectiveCamera } from '@react-three/drei';
import * as THREE from 'three';
import { IndustrialTerrain, DustParticles } from './IndustrialEnvironment';
import {
  Excavator3DModel,
  Bobcat3DModel,
  Backhoe3DModel,
  Drilling3DModel,
  Solar3DModel,
} from './MachineryModels';

interface Hero3DCanvasProps {
  mousePos: { x: number; y: number };
}

function Hero3DScene({ mousePos }: Hero3DCanvasProps) {
  const cameraGroup = useRef<THREE.Group>(null!);

  useFrame(() => {
    if (!cameraGroup.current) return;
    // Smooth mouse parallax movement
    const targetX = mousePos.x * 1.2;
    const targetY = mousePos.y * 0.8;

    cameraGroup.current.position.x += (targetX - cameraGroup.current.position.x) * 0.05;
    cameraGroup.current.position.y += (targetY - cameraGroup.current.position.y) * 0.05;
  });

  return (
    <group ref={cameraGroup}>
      {/* Lighting Suite */}
      <ambientLight intensity={0.6} />
      <directionalLight
        position={[10, 15, 10]}
        intensity={2.2}
        color="#FFFFFF"
        castShadow
        shadow-mapSize-width={1024}
        shadow-mapSize-height={1024}
      />
      {/* Industrial Accent Spotlights */}
      <spotLight
        position={[-8, 12, -5]}
        intensity={4.5}
        color="#F5B800"
        angle={0.6}
        penumbra={0.8}
        castShadow
      />
      <spotLight
        position={[8, 6, 8]}
        intensity={3.0}
        color="#FFD23F"
        angle={0.5}
        penumbra={0.5}
      />

      <fog attach="fog" args={['#080A0B', 12, 35]} />

      {/* Hero Central Excavator Model */}
      <group position={[0, 0, 0]} rotation={[0, -0.4, 0]}>
        <Excavator3DModel animateArm={true} />
      </group>

      {/* Industrial Terrain & Floating Particles */}
      <IndustrialTerrain />
      <DustParticles count={150} />
    </group>
  );
}

export default function Hero3DCanvas({ mousePos }: Hero3DCanvasProps) {
  return (
    <div className="w-full h-full relative">
      <Canvas shadows gl={{ antialias: true, alpha: false, powerPreference: 'high-performance' }}>
        <PerspectiveCamera makeDefault position={[0, 2.2, 8.5]} fov={45} />
        <Suspense fallback={null}>
          <Hero3DScene mousePos={mousePos} />
        </Suspense>
      </Canvas>
    </div>
  );
}

// Interactive 3D Fleet Showroom Viewer Component
export function FleetShowroomCanvas({ modelType }: { modelType: string }) {
  return (
    <div className="w-full h-full relative cursor-grab active:cursor-grabbing">
      <Canvas shadows gl={{ antialias: true }}>
        <PerspectiveCamera makeDefault position={[0, 2.2, 7.5]} fov={42} />
        <ambientLight intensity={0.8} />
        <directionalLight position={[10, 15, 10]} intensity={2.5} color="#FFF" castShadow />
        <spotLight position={[-6, 10, -4]} intensity={4} color="#F5B800" />
        <spotLight position={[6, 5, 6]} intensity={2.5} color="#FFD23F" />
        <fog attach="fog" args={['#15191C', 10, 28]} />

        <Suspense fallback={null}>
          <group position={[0, -0.2, 0]}>
            {modelType === 'excavator' && <Excavator3DModel animateArm={false} />}
            {modelType === 'bobcat' && <Bobcat3DModel />}
            {modelType === 'backhoe' && <Backhoe3DModel />}
            {modelType === 'drilling' && <Drilling3DModel />}
            {modelType === 'solar' && <Solar3DModel />}
          </group>
          <IndustrialTerrain gridColor="#F5B800" />
          <DustParticles count={80} />
        </Suspense>

        <OrbitControls
          enableZoom={true}
          maxDistance={12}
          minDistance={4}
          maxPolarAngle={Math.PI / 2 - 0.05}
          autoRotate={true}
          autoRotateSpeed={0.8}
        />
      </Canvas>
    </div>
  );
}

// Interactive Solar Infrastructure 3D Canvas
export function Solar3DCanvas() {
  return (
    <div className="w-full h-full relative">
      <Canvas shadows gl={{ antialias: true }}>
        <PerspectiveCamera makeDefault position={[0, 2.5, 7.0]} fov={45} />
        <ambientLight intensity={0.9} />
        <directionalLight position={[12, 18, 10]} intensity={3.0} color="#FFFFFF" castShadow />
        <spotLight position={[-8, 12, -4]} intensity={5.0} color="#F5B800" />
        <fog attach="fog" args={['#080A0B', 8, 25]} />

        <Suspense fallback={null}>
          <group position={[0, -0.2, 0]}>
            <Solar3DModel />
          </group>
          <IndustrialTerrain gridColor="#F5B800" />
          <DustParticles count={100} />
        </Suspense>

        <OrbitControls
          enableZoom={false}
          maxPolarAngle={Math.PI / 2 - 0.05}
          autoRotate={true}
          autoRotateSpeed={1.2}
        />
      </Canvas>
    </div>
  );
}

// Finale Spotlight Machine 3D Canvas
export function Finale3DCanvas() {
  return (
    <div className="w-full h-full relative">
      <Canvas shadows gl={{ antialias: true }}>
        <PerspectiveCamera makeDefault position={[0, 1.8, 6.8]} fov={40} />
        <ambientLight intensity={0.15} />
        {/* Dark dramatic yellow spotlights */}
        <spotLight
          position={[0, 10, 0]}
          intensity={12.0}
          color="#F5B800"
          angle={0.45}
          penumbra={0.7}
          castShadow
        />
        <spotLight
          position={[-5, 3, 4]}
          intensity={4.0}
          color="#FFD23F"
          angle={0.5}
        />
        <fog attach="fog" args={['#080A0B', 5, 18]} />

        <Suspense fallback={null}>
          <group position={[0, -0.2, 0]} rotation={[0, 0.5, 0]}>
            <Excavator3DModel animateArm={false} />
          </group>
          <IndustrialTerrain />
          <DustParticles count={60} />
        </Suspense>

        <OrbitControls
          enableZoom={false}
          enablePan={false}
          maxPolarAngle={Math.PI / 2 - 0.05}
          autoRotate={true}
          autoRotateSpeed={0.5}
        />
      </Canvas>
    </div>
  );
}
