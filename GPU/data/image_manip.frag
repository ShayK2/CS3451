// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
  vec4 diffuse_color = texture2D(texture, vertTexCoord.xy);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);

  vec4 blur = vec4(0.0, 0.0, 0.0, 0.0);
  for (int i = -10; i < 11; i++) for (int j = -10; j < 11; j++) blur += texture2D(texture, vec2(vertTexCoord.x + i * 1.0/256.0, vertTexCoord.y + j * 1.0/256.0));
  gl_FragColor = blur / 441.0;
}