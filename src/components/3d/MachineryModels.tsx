import React, { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const darkMetal = new THREE.MeshStandardMaterial({
  color: '#15191C',
  metalness: 0.85,
  roughness: 0.35,
});

const yellowBody = new THREE.MeshStandardMaterial({
  color: '#F5B800',
  metalness: 0.2,
  roughness: 0.4,
});

const brightYellow = new THREE.MeshStandardMaterial({
  color: '#FFD23F',
  metalness: 0.1,
  roughness: 0.3,
  emissive: '#F5B800',
  emissiveIntensity: 0.15,
});

const trackMaterial = new THREE.MeshStandardMaterial({
  color: '#0D0E10',
  metalness: 0.9,
  roughness: 0.8,
});

const glassMaterial = new THREE.MeshPhysicalMaterial({
  color: '#15191C',
  metalness: 0.1,
  roughness: 0.1,
  transmission: 0.85,
  thickness: 0.5,
  transparent: true,
  opacity: 0.6,
});

const hydraulicMaterial = new THREE.MeshStandardMaterial({
  color: '#E0E0E0',
  metalness: 0.95,
  roughness: 0.1,
});

// 1. EXCAVATOR MODEL
export function Excavator3DModel({ animateArm = true }: { animateArm?: boolean }) {
  const cabinGroup = useRef<THREE.Group>(null!);
  const boomArm = useRef<THREE.Group>(null!);
  const stickArm = useRef<THREE.Group>(null!);
  const bucketGroup = useRef<THREE.Group>(null!);

  useFrame((state) => {
    if (!animateArm) return;
    const t = state.clock.getElapsedTime();
    if (cabinGroup.current) {
      cabinGroup.current.rotation.y = Math.sin(t * 0.4) * 0.15;
    }
    if (boomArm.current) {
      boomArm.current.rotation.z = Math.sin(t * 0.6) * 0.08 - 0.1;
    }
    if (stickArm.current) {
      stickArm.current.rotation.z = Math.cos(t * 0.6) * 0.1 + 0.4;
    }
    if (bucketGroup.current) {
      bucketGroup.current.rotation.z = Math.sin(t * 0.8) * 0.1 - 0.3;
    }
  });

  return (
    <group position={[0, 0, 0]} scale={1.1}>
      {/* Undercarriage & Tracks */}
      <group position={[0, 0.4, 0]}>
        {/* Left Track */}
        <mesh position={[-1.3, 0, 0]} material={trackMaterial} castShadow receiveShadow>
          <boxGeometry args={[0.6, 0.8, 4.2]} />
        </mesh>
        {/* Track Wheels Left */}
        {[-1.6, -0.8, 0, 0.8, 1.6].map((z, i) => (
          <mesh key={i} position={[-1.3, -0.1, z]} rotation={[0, 0, Math.PI / 2]} material={darkMetal}>
            <cylinderGeometry args={[0.35, 0.35, 0.62, 16]} />
          </mesh>
        ))}

        {/* Right Track */}
        <mesh position={[1.3, 0, 0]} material={trackMaterial} castShadow receiveShadow>
          <boxGeometry args={[0.6, 0.8, 4.2]} />
        </mesh>
        {/* Track Wheels Right */}
        {[-1.6, -0.8, 0, 0.8, 1.6].map((z, i) => (
          <mesh key={i} position={[1.3, -0.1, z]} rotation={[0, 0, Math.PI / 2]} material={darkMetal}>
            <cylinderGeometry args={[0.35, 0.35, 0.62, 16]} />
          </mesh>
        ))}

        {/* Center Base Chassis */}
        <mesh position={[0, 0.2, 0]} material={darkMetal} castShadow receiveShadow>
          <boxGeometry args={[2.0, 0.5, 3.2]} />
        </mesh>
      </group>

      {/* Rotating House / Upper Cabin Structure */}
      <group ref={cabinGroup} position={[0, 0.9, 0]}>
        {/* Main Body Engine Counterweight Housing */}
        <mesh position={[0, 0.6, -0.8]} material={yellowBody} castShadow receiveShadow>
          <boxGeometry args={[2.4, 1.1, 2.2]} />
        </mesh>
        {/* Heavy Rear Counterweight */}
        <mesh position={[0, 0.65, -1.8]} material={darkMetal} castShadow receiveShadow>
          <boxGeometry args={[2.42, 1.15, 0.6]} />
        </mesh>
        {/* ORVEXA Side Accent Strip */}
        <mesh position={[1.22, 0.6, -0.8]} material={brightYellow}>
          <boxGeometry args={[0.02, 0.3, 2.0]} />
        </mesh>
        <mesh position={[-1.22, 0.6, -0.8]} material={brightYellow}>
          <boxGeometry args={[0.02, 0.3, 2.0]} />
        </mesh>

        {/* Operator Cabin */}
        <group position={[-0.7, 1.0, 0.4]}>
          <mesh material={darkMetal} castShadow>
            <boxGeometry args={[0.9, 1.3, 1.4]} />
          </mesh>
          {/* Glass Windows */}
          <mesh position={[0, 0.1, 0.05]} material={glassMaterial}>
            <boxGeometry args={[0.92, 1.1, 1.32]} />
          </mesh>
          {/* Top Work Lights */}
          <mesh position={[0.3, 0.68, 0.65]} material={brightYellow}>
            <boxGeometry args={[0.2, 0.1, 0.1]} />
          </mesh>
        </group>

        {/* Boom Joint & Main Hydraulic Base */}
        <group position={[0.4, 0.8, 0.6]}>
          <mesh rotation={[0, 0, Math.PI / 2]} material={darkMetal}>
            <cylinderGeometry args={[0.3, 0.3, 0.6, 16]} />
          </mesh>

          {/* Main Boom Arm */}
          <group ref={boomArm} rotation={[-0.4, 0, 0]}>
            <mesh position={[0, 1.5, 1.0]} rotation={[0.4, 0, 0]} material={yellowBody} castShadow>
              <boxGeometry args={[0.4, 3.2, 0.5]} />
            </mesh>
            {/* Hydraulic Cylinder */}
            <mesh position={[0, 0.8, 0.4]} rotation={[0.2, 0, 0]} material={hydraulicMaterial}>
              <cylinderGeometry args={[0.08, 0.08, 1.8, 16]} />
            </mesh>

            {/* Stick Arm Joint */}
            <group ref={stickArm} position={[0, 2.9, 2.0]} rotation={[0.8, 0, 0]}>
              <mesh position={[0, 1.0, -0.2]} rotation={[-0.2, 0, 0]} material={darkMetal} castShadow>
                <boxGeometry args={[0.35, 2.4, 0.4]} />
              </mesh>

              {/* Bucket Joint */}
              <group ref={bucketGroup} position={[0, 2.0, -0.5]} rotation={[-0.6, 0, 0]}>
                {/* Heavy Bucket */}
                <mesh position={[0, 0.2, -0.3]} material={yellowBody} castShadow>
                  <boxGeometry args={[0.9, 0.7, 0.8]} />
                </mesh>
                {/* Bucket Teeth */}
                {[-0.35, -0.18, 0, 0.18, 0.35].map((x, i) => (
                  <mesh key={i} position={[x, -0.15, -0.7]} rotation={[0.4, 0, 0]} material={brightYellow}>
                    <coneGeometry args={[0.05, 0.3, 4]} />
                  </mesh>
                ))}
              </group>
            </group>
          </group>
        </group>
      </group>
    </group>
  );
}

// 2. COMPACT TRACK LOADER (BOBCAT) MODEL
export function Bobcat3DModel() {
  const liftArm = useRef<THREE.Group>(null!);

  useFrame((state) => {
    const t = state.clock.getElapsedTime();
    if (liftArm.current) {
      liftArm.current.rotation.x = Math.sin(t * 0.8) * 0.08 - 0.05;
    }
  });

  return (
    <group position={[0, 0, 0]} scale={1.2}>
      {/* Compact Tracks */}
      <group position={[0, 0.3, 0]}>
        <mesh position={[-0.85, 0, 0]} material={trackMaterial} castShadow>
          <boxGeometry args={[0.4, 0.6, 2.2]} />
        </mesh>
        <mesh position={[0.85, 0, 0]} material={trackMaterial} castShadow>
          <boxGeometry args={[0.4, 0.6, 2.2]} />
        </mesh>
      </group>

      {/* Main Body Frame */}
      <group position={[0, 0.7, 0]}>
        <mesh material={darkMetal} castShadow>
          <boxGeometry args={[1.3, 0.8, 2.0]} />
        </mesh>
        <mesh position={[0, 0.3, -0.2]} material={yellowBody} castShadow>
          <boxGeometry args={[1.32, 0.6, 1.4]} />
        </mesh>

        {/* Cab Roll Cage */}
        <mesh position={[0, 0.8, 0]} material={darkMetal} castShadow>
          <boxGeometry args={[1.0, 1.0, 1.1]} />
        </mesh>
        <mesh position={[0, 0.8, 0]} material={glassMaterial}>
          <boxGeometry args={[1.02, 0.95, 1.12]} />
        </mesh>

        {/* Lift Arms & Bucket */}
        <group ref={liftArm} position={[0, 0.4, -0.6]}>
          {/* Side Arm Left */}
          <mesh position={[-0.72, 0.3, 1.0]} rotation={[-0.2, 0, 0]} material={yellowBody}>
            <boxGeometry args={[0.12, 0.25, 2.2]} />
          </mesh>
          {/* Side Arm Right */}
          <mesh position={[0.72, 0.3, 1.0]} rotation={[-0.2, 0, 0]} material={yellowBody}>
            <boxGeometry args={[0.12, 0.25, 2.2]} />
          </mesh>
          {/* Loader Bucket */}
          <mesh position={[0, 0.1, 2.1]} rotation={[0.2, 0, 0]} material={darkMetal} castShadow>
            <boxGeometry args={[1.6, 0.6, 0.7]} />
          </mesh>
          <mesh position={[0, 0.35, 2.2]} material={brightYellow}>
            <boxGeometry args={[1.62, 0.08, 0.08]} />
          </mesh>
        </group>
      </group>
    </group>
  );
}

// 3. BACKHOE LOADER MODEL
export function Backhoe3DModel() {
  return (
    <group position={[0, 0, 0]} scale={1.05}>
      {/* Wheels */}
      <group position={[0, 0.5, 0]}>
        {/* Large Rear Wheels */}
        <mesh position={[-1.1, 0.2, -1.2]} rotation={[0, 0, Math.PI / 2]} material={trackMaterial} castShadow>
          <cylinderGeometry args={[0.7, 0.7, 0.5, 24]} />
        </mesh>
        <mesh position={[1.1, 0.2, -1.2]} rotation={[0, 0, Math.PI / 2]} material={trackMaterial} castShadow>
          <cylinderGeometry args={[0.7, 0.7, 0.5, 24]} />
        </mesh>
        {/* Front Wheels */}
        <mesh position={[-1.0, -0.1, 1.3]} rotation={[0, 0, Math.PI / 2]} material={trackMaterial} castShadow>
          <cylinderGeometry args={[0.45, 0.45, 0.4, 20]} />
        </mesh>
        <mesh position={[1.0, -0.1, 1.3]} rotation={[0, 0, Math.PI / 2]} material={trackMaterial} castShadow>
          <cylinderGeometry args={[0.45, 0.45, 0.4, 20]} />
        </mesh>
      </group>

      {/* Main Body Chassis */}
      <group position={[0, 1.1, 0]}>
        <mesh material={yellowBody} castShadow>
          <boxGeometry args={[1.5, 0.9, 3.0]} />
        </mesh>
        {/* Cabin */}
        <mesh position={[0, 0.9, -0.2]} material={darkMetal} castShadow>
          <boxGeometry args={[1.3, 1.2, 1.4]} />
        </mesh>
        <mesh position={[0, 0.9, -0.2]} material={glassMaterial}>
          <boxGeometry args={[1.32, 1.15, 1.42]} />
        </mesh>

        {/* Front Loader Bucket */}
        <group position={[0, -0.3, 1.9]}>
          <mesh material={darkMetal} castShadow>
            <boxGeometry args={[1.8, 0.7, 0.8]} />
          </mesh>
          <mesh position={[0, 0.36, 0.1]} material={brightYellow}>
            <boxGeometry args={[1.82, 0.08, 0.1]} />
          </mesh>
        </group>

        {/* Rear Digging Arm */}
        <group position={[0, 0, -1.8]} rotation={[0.3, 0, 0]}>
          <mesh position={[0, 0.8, -0.6]} material={yellowBody} castShadow>
            <boxGeometry args={[0.3, 1.8, 0.35]} />
          </mesh>
          <mesh position={[0, 1.5, -1.1]} rotation={[-0.8, 0, 0]} material={darkMetal} castShadow>
            <boxGeometry args={[0.25, 1.2, 0.3]} />
          </mesh>
          <mesh position={[0, 1.0, -1.7]} rotation={[0.4, 0, 0]} material={yellowBody} castShadow>
            <boxGeometry args={[0.5, 0.5, 0.5]} />
          </mesh>
        </group>
      </group>
    </group>
  );
}

// 4. DRILLING RIG MODEL
export function Drilling3DModel() {
  const drillBit = useRef<THREE.Group>(null!);

  useFrame((state) => {
    if (drillBit.current) {
      drillBit.current.rotation.y = state.clock.getElapsedTime() * 4;
    }
  });

  return (
    <group position={[0, 0, 0]} scale={1.0}>
      {/* Heavy Steel Base & Orugas */}
      <group position={[0, 0.4, 0]}>
        <mesh position={[-1.2, 0, 0]} material={trackMaterial} castShadow>
          <boxGeometry args={[0.5, 0.8, 4.0]} />
        </mesh>
        <mesh position={[1.2, 0, 0]} material={trackMaterial} castShadow>
          <boxGeometry args={[0.5, 0.8, 4.0]} />
        </mesh>
        <mesh material={darkMetal} castShadow>
          <boxGeometry args={[2.0, 0.6, 3.0]} />
        </mesh>
      </group>

      {/* Main Rig Base */}
      <group position={[0, 1.0, 0]}>
        <mesh material={yellowBody} castShadow>
          <boxGeometry args={[2.2, 0.8, 2.5]} />
        </mesh>

        {/* Vertical Tower Rig Mast */}
        <group position={[0, 2.8, 1.0]}>
          <mesh material={darkMetal} castShadow>
            <boxGeometry args={[0.7, 5.2, 0.7]} />
          </mesh>
          {/* Yellow Spine Accent */}
          <mesh position={[0, 0, -0.38]} material={brightYellow}>
            <boxGeometry args={[0.6, 5.0, 0.08]} />
          </mesh>

          {/* Rotary Drill Head & Auger Bit */}
          <group ref={drillBit} position={[0, -0.5, 0.6]}>
            {/* Top Drive Motor */}
            <mesh material={yellowBody}>
              <boxGeometry args={[0.8, 0.6, 0.8]} />
            </mesh>
            {/* Drilling Rod */}
            <mesh position={[0, -1.8, 0]} material={hydraulicMaterial}>
              <cylinderGeometry args={[0.12, 0.12, 3.2, 16]} />
            </mesh>
            {/* Auger Spiral Screw */}
            {[-0.8, -1.2, -1.6, -2.0, -2.4, -2.8].map((y, i) => (
              <mesh key={i} position={[0, y, 0]} rotation={[0, i * 0.8, 0]} material={darkMetal}>
                <cylinderGeometry args={[0.5, 0.5, 0.1, 16]} />
              </mesh>
            ))}
          </group>
        </group>
      </group>
    </group>
  );
}

// 5. SOLAR PILING & PANEL MODEL
export function Solar3DModel() {
  const piler = useRef<THREE.Group>(null!);

  useFrame((state) => {
    const t = state.clock.getElapsedTime();
    if (piler.current) {
      piler.current.position.y = Math.sin(t * 3) * 0.15 + 1.2;
    }
  });

  return (
    <group position={[0, 0, 0]} scale={1.1}>
      {/* Solar Piling Machine on Left */}
      <group position={[-1.6, 0, 0]}>
        {/* Orugas */}
        <mesh position={[0, 0.3, 0]} material={trackMaterial} castShadow>
          <boxGeometry args={[1.2, 0.5, 2.2]} />
        </mesh>
        <mesh position={[0, 0.8, 0]} material={yellowBody} castShadow>
          <boxGeometry args={[1.1, 0.6, 1.8]} />
        </mesh>
        {/* Piling Mast */}
        <mesh position={[0, 2.2, 0.8]} material={darkMetal} castShadow>
          <boxGeometry args={[0.4, 3.4, 0.4]} />
        </mesh>
        {/* Impact Hammer */}
        <mesh ref={piler} position={[0, 1.2, 0.8]} material={brightYellow}>
          <boxGeometry args={[0.5, 0.6, 0.5]} />
        </mesh>
      </group>

      {/* Solar Panel Array on Right */}
      <group position={[1.2, 0, 0]}>
        {/* Ground Posts */}
        <mesh position={[-0.8, 0.8, -0.8]} material={hydraulicMaterial}>
          <cylinderGeometry args={[0.06, 0.06, 1.6, 12]} />
        </mesh>
        <mesh position={[0.8, 0.8, -0.8]} material={hydraulicMaterial}>
          <cylinderGeometry args={[0.06, 0.06, 1.6, 12]} />
        </mesh>
        <mesh position={[-0.8, 0.8, 0.8]} material={hydraulicMaterial}>
          <cylinderGeometry args={[0.06, 0.06, 1.6, 12]} />
        </mesh>
        <mesh position={[0.8, 0.8, 0.8]} material={hydraulicMaterial}>
          <cylinderGeometry args={[0.06, 0.06, 1.6, 12]} />
        </mesh>

        {/* Tilted Solar Panel Table */}
        <group position={[0, 1.6, 0]} rotation={[0.4, 0, 0]}>
          <mesh material={darkMetal} castShadow>
            <boxGeometry args={[3.2, 0.06, 2.4]} />
          </mesh>
          {/* Photovoltaic Cells Surface */}
          <mesh position={[0, 0.04, 0]}>
            <boxGeometry args={[3.15, 0.02, 2.35]} />
            <meshStandardMaterial
              color="#0B2545"
              metalness={0.9}
              roughness={0.1}
              emissive="#134074"
              emissiveIntensity={0.2}
            />
          </mesh>
          {/* Solar Panel Grid Lines */}
          <gridHelper args={[3.0, 6, '#F5B800', '#252B2F']} position={[0, 0.06, 0]} />
        </group>
      </group>
    </group>
  );
}
