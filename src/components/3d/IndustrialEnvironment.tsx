import React, { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';

export function DustParticles({ count = 120 }: { count?: number }) {
  const meshRef = useRef<THREE.InstancedMesh>(null!);
  const dummy = useRef(new THREE.Object3D());

  const particles = useRef(
    Array.from({ length: count }, () => ({
      position: [
        (Math.random() - 0.5) * 20,
        Math.random() * 8 + 0.2,
        (Math.random() - 0.5) * 20,
      ] as [number, number, number],
      speed: Math.random() * 0.005 + 0.002,
      scale: Math.random() * 0.05 + 0.02,
      rotationSpeed: (Math.random() - 0.5) * 0.01,
    }))
  );

  useFrame((state) => {
    if (!meshRef.current) return;
    const time = state.clock.getElapsedTime();

    particles.current.forEach((particle, i) => {
      particle.position[1] += particle.speed;
      if (particle.position[1] > 8) {
        particle.position[1] = 0.2;
      }

      const px = particle.position[0] + Math.sin(time + i) * 0.2;
      const py = particle.position[1];
      const pz = particle.position[2] + Math.cos(time + i) * 0.2;

      dummy.current.position.set(px, py, pz);
      dummy.current.scale.set(particle.scale, particle.scale, particle.scale);
      dummy.current.rotation.y += particle.rotationSpeed;
      dummy.current.updateMatrix();

      meshRef.current.setMatrixAt(i, dummy.current.matrix);
    });

    meshRef.current.instanceMatrix.needsUpdate = true;
  });

  return (
    <instancedMesh
      ref={meshRef}
      args={[undefined, undefined, count]}
      castShadow={false}
      receiveShadow={false}
    >
      <dodecahedronGeometry args={[0.5, 0]} />
      <meshStandardMaterial
        color="#F5B800"
        emissive="#F5B800"
        emissiveIntensity={0.6}
        transparent
        opacity={0.35}
        roughness={1}
      />
    </instancedMesh>
  );
}

export function IndustrialTerrain({ gridColor = '#252B2F' }: { gridColor?: string }) {
  return (
    <group position={[0, -0.01, 0]}>
      {/* Dark reflective ground floor */}
      <mesh rotation={[-Math.PI / 2, 0, 0]} receiveShadow>
        <planeGeometry args={[100, 100]} />
        <meshStandardMaterial
          color="#080A0B"
          roughness={0.85}
          metalness={0.2}
        />
      </mesh>

      {/* Raised central industrial platform */}
      <mesh position={[0, -0.1, 0]} receiveShadow>
        <cylinderGeometry args={[9, 10, 0.2, 32]} />
        <meshStandardMaterial color="#15191C" roughness={0.7} metalness={0.4} />
      </mesh>

      {/* Subtle Grid overlay */}
      <gridHelper
        args={[80, 80, '#F5B800', gridColor]}
        position={[0, 0.01, 0]}
      />
    </group>
  );
}
