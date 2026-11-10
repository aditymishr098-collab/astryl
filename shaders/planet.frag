#version 460 core

// Draws one lit, rotatable planet. The surface is generated from noise, so
// the app needs no texture files and works fully offline.
//
// Uniform order matters: lib/widgets/globe_view.dart sets them by index.

#include <flutter/runtime_effect.glsl>

precision highp float;

uniform vec2 uSize;        // 0, 1
uniform float uYaw;        // 2  spin around the planet's axis
uniform float uPitch;      // 3  looking from above (-) or below (+)
uniform float uRoll;       // 4  axial tilt on screen
uniform float uZoom;       // 5  planet radius as part of half the box
uniform vec3 uColorA;      // 6, 7, 8
uniform vec3 uColorB;      // 9, 10, 11
uniform vec3 uColorC;      // 12, 13, 14
uniform float uStyle;      // 15  0 rocky, 1 earth, 2 banded, 3 ice, 4 sun, 5 icy moon
uniform float uCaps;       // 16  polar caps
uniform float uSpot;       // 17  Jupiter's Great Red Spot
uniform float uSeed;       // 18
uniform vec3 uGlow;        // 19, 20, 21  atmosphere colour
uniform float uGlowAmount; // 22
uniform float uTime;       // 23  seconds, moves Earth's clouds
uniform vec2 uCenter;      // 24, 25  planet centre in the drawn area
uniform vec3 uLight;       // 26, 27, 28  direction to the light, view space

out vec4 fragColor;

float hash(vec3 p) {
  p = fract(p * 0.3183099 + vec3(0.11, 0.17, 0.23) + vec3(uSeed));
  p *= 17.0;
  return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

float noise(vec3 x) {
  vec3 i = floor(x);
  vec3 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  float n000 = hash(i);
  float n100 = hash(i + vec3(1.0, 0.0, 0.0));
  float n010 = hash(i + vec3(0.0, 1.0, 0.0));
  float n110 = hash(i + vec3(1.0, 1.0, 0.0));
  float n001 = hash(i + vec3(0.0, 0.0, 1.0));
  float n101 = hash(i + vec3(1.0, 0.0, 1.0));
  float n011 = hash(i + vec3(0.0, 1.0, 1.0));
  float n111 = hash(i + vec3(1.0, 1.0, 1.0));
  float a = mix(mix(n000, n100, f.x), mix(n010, n110, f.x), f.y);
  float b = mix(mix(n001, n101, f.x), mix(n011, n111, f.x), f.y);
  return mix(a, b, f.z);
}

float fbm(vec3 p) {
  float v = 0.0;
  float a = 0.5;
  for (int i = 0; i < 5; i++) {
    v += a * noise(p);
    p = p * 2.03 + vec3(1.7, 9.2, 3.4);
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 center = uCenter;
  float radius = min(uSize.x, uSize.y) * 0.5 * uZoom;
  vec2 d = (frag - center) / radius;
  float r2 = dot(d, d);
  float r = sqrt(r2);

  if (r > 1.0) {
    // Thin glow just outside the planet for planets with an atmosphere.
    float g = uGlowAmount * 0.55 * (1.0 - smoothstep(1.0, 1.07, r));
    fragColor = vec4(uGlow * g, g);
    return;
  }

  float z = sqrt(max(0.0, 1.0 - r2));
  // View space, y pointing up.
  vec3 n = vec3(d.x, -d.y, z);

  // Undo the axial tilt, then the viewing angle, then the spin.
  float cr = cos(uRoll);
  float sr = sin(uRoll);
  vec3 n1 = vec3(cr * n.x + sr * n.y, -sr * n.x + cr * n.y, n.z);
  float cp = cos(uPitch);
  float sp = sin(uPitch);
  vec3 q = vec3(n1.x, cp * n1.y - sp * n1.z, sp * n1.y + cp * n1.z);
  float cy = cos(uYaw);
  float sy = sin(uYaw);
  vec3 b = vec3(cy * q.x + sy * q.z, q.y, -sy * q.x + cy * q.z);

  float lat = asin(clamp(b.y, -1.0, 1.0));
  float lon = atan(b.z, b.x);

  vec3 col;
  if (uStyle < 0.5) {
    // Rocky: Mercury, Mars.
    float h = fbm(b * 3.0);
    float spots = fbm(b * 9.0 + vec3(4.0));
    col = mix(uColorB, uColorA, smoothstep(0.3, 0.7, h));
    col = mix(col, uColorC, smoothstep(0.55, 0.8, spots) * 0.6);
  } else if (uStyle < 1.5) {
    // Earth: oceans, land and moving clouds.
    float h = fbm(b * 2.2 + vec3(3.1));
    float land = smoothstep(0.50, 0.53, h);
    vec3 ocean = mix(uColorA * 0.65, uColorA, smoothstep(0.25, 0.5, h));
    float dry = clamp(smoothstep(0.58, 0.75, h) + 0.25 * abs(b.y), 0.0, 1.0);
    vec3 ground = mix(uColorB, uColorC, dry);
    col = mix(ocean, ground, land);
    float clouds = fbm(b * 3.5 + vec3(uTime * 0.03, 0.0, uTime * 0.01));
    col = mix(col, vec3(1.0), smoothstep(0.56, 0.78, clouds) * 0.85);
  } else if (uStyle < 2.5) {
    // Banded: Venus, Jupiter, Saturn.
    float warp = fbm(b * 3.0);
    float band = sin(lat * 14.0 + warp * 2.4);
    float band2 = sin(lat * 31.0 + warp * 3.6);
    col = mix(uColorA, uColorB, smoothstep(-0.2, 0.8, band));
    col = mix(col, uColorC, smoothstep(0.4, 1.0, band2) * 0.5);
    if (uSpot > 0.5) {
      vec2 s = vec2((lon - 0.8) * 2.2, (lat + 0.38) * 6.0);
      float spot = 1.0 - smoothstep(0.6, 1.0, length(s));
      col = mix(col, vec3(0.78, 0.36, 0.22), spot * 0.85);
    }
  } else if (uStyle < 3.5) {
    // Ice giants and hazy Titan.
    float band = sin(lat * 8.0 + fbm(b * 2.0) * 1.5);
    col = mix(uColorA, uColorB, 0.5 + 0.25 * band);
    col = mix(col, uColorC, smoothstep(0.6, 1.0, fbm(b * 4.0)) * 0.3);
  } else if (uStyle < 4.5) {
    // The Sun: boiling granules and darker spots.
    float g = fbm(b * 9.0 + vec3(uTime * 0.06, uTime * 0.04, 0.0));
    col = mix(uColorB, uColorA, smoothstep(0.25, 0.7, g));
    col = mix(col, uColorC, smoothstep(0.62, 0.85, fbm(b * 3.0 - vec3(uTime * 0.02))) * 0.6);
  } else {
    // Icy moons: bright ice crossed by thin dark cracks.
    col = mix(uColorA, uColorC, fbm(b * 3.0));
    float crack = abs(noise(b * 5.0) - 0.5);
    float crack2 = abs(noise(b * 11.0 + vec3(2.0)) - 0.5);
    float lines = (1.0 - smoothstep(0.0, 0.035, crack)) + 0.6 * (1.0 - smoothstep(0.0, 0.025, crack2));
    col = mix(col, uColorB, clamp(lines, 0.0, 1.0) * 0.75);
  }

  if (uCaps > 0.5) {
    float cap = smoothstep(1.12, 1.22, abs(lat) + fbm(b * 6.0) * 0.15);
    col = mix(col, vec3(0.95, 0.96, 0.98), cap);
  }

  // Sunlight from uLight, plus a little ambient light. The Sun makes
  // its own light, so it only gets darker towards its edge.
  vec3 light = normalize(uLight);
  float diffuse = max(dot(n, light), 0.0);
  if (uStyle > 3.5 && uStyle < 4.5) {
    diffuse = 1.0;
    col *= 0.55 + 0.5 * z;
  } else {
    col *= 0.10 + 0.95 * diffuse;
    // Earth night-side city lights and polar aurora
    if (uStyle > 0.5 && uStyle < 1.5) {
      float night = smoothstep(0.18, -0.08, dot(n, light));
      float hLand = fbm(b * 2.2 + vec3(3.1));
      float isLand = smoothstep(0.51, 0.55, hLand);
      float cityMask = smoothstep(0.62, 0.78, fbm(b * 14.0 + vec3(5.2)));
      col += vec3(1.0, 0.78, 0.36) * (night * isLand * cityMask * 0.75);

      // Polar aurora oval around 65-72 deg latitude
      float auroraBand = exp(-pow((abs(lat) - 1.18) * 11.0, 2.0));
      float auroraWave = 0.5 + 0.5 * sin(lon * 7.0 + uTime * 1.4 + fbm(b * 5.0) * 4.0);
      col += vec3(0.18, 0.92, 0.55) * (auroraBand * auroraWave * (0.35 + 0.65 * night) * 0.42);
    }
  }

  // Atmosphere rim.
  float rim = pow(1.0 - z, 2.5) * uGlowAmount;
  col += uGlow * rim * (0.25 + 0.75 * diffuse);

  // Smooth edge, one pixel wide.
  float edge = clamp((1.0 - r) * radius, 0.0, 1.0);
  fragColor = vec4(col * edge, edge);
}
