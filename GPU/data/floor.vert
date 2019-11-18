
#define PROCESSING_LIGHT_SHADER

// Set automatically by Processing
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;


// Come from the geometry/material of the object
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

// These values will be sent to the fragment shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {
  vertColor = color;
  
  vertNormal = normalize(normalMatrix * normal);
  
  vec4 vert = vertex;

  gl_Position = transform * vert; 
  vertLightDir = normalize(-lightNormal);
}
