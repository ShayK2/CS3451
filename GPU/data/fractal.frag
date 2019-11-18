// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  vec4 background = vec4(1.0, 0.0, 0.0, 1.0);
  float diffuse = clamp(dot(vertNormal, vertLightDir), 0.0, 1.0);
  vec4 fractalColor = vec4(1.0, 1.0, 1.0, 1.0);
  
  float x = (vertTexCoord.x * 3.0) - 1.5;
  float y = (vertTexCoord.y * 3.0) - 1.5;

  for (int i = 0; i < 20; i++) {
  	float newX = (x * x) - (y * y) + cx;
  	y = 2 * x * y + cy;
  	x = newX;
  }
  gl_FragColor = sqrt((x * x) + (y * y)) < 4 ? vec4(diffuse * fractalColor.rgb, 1.0) : vec4(diffuse * background.rgb, 1.0);
}