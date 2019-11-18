// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  bool inCircle = false;
  for (int i = 0; i < 5; i++) {
    vec2 center = vec2(0.225 + 0.15 * i, 0.275 + 0.075 * (i % 2 == 0 ? -1 : 1));
    float dist = sqrt(((vertTexCoord.x - center.x) * (vertTexCoord.x - center.x)) + ((vertTexCoord.y - center.y) * (vertTexCoord.y - center.y)));
    if (dist < 0.15 && dist > 0.12) inCircle = true;
  }
  gl_FragColor = inCircle ? vec4(0.0, 1.0, 1.0, 1.0) : vec4(0.0, 1.0, 1.0, 0);
}