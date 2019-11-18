// Akshay Karthik
// CS 3451-A

// Declare global variables
PShader floor_shader, circle_shader, fractal_shader, image_manip_shader, bumps_shader;
PImage duck_texture, bumps_texture;

float offsetY, offsetX;
float zoom = -200;
boolean locked = false;
float dirY = 0;
float dirX = 0;
float time = 0;

// initialize variables and load shaders
void setup() {
  size(640, 640, P3D);
  offsetX = width/2;
  offsetY = height/2;
  noStroke();
  fill(204);

  // load some textures
  duck_texture = loadImage("data/pic_duck.bmp");
  bumps_texture = loadImage("data/pic_bumps.jpg");

  // load the shaders
  circle_shader = loadShader("data/rings.frag", "data/rings.vert");
  fractal_shader = loadShader("data/fractal.frag", "data/fractal.vert");
  image_manip_shader = loadShader("data/image_manip.frag", "data/image_manip.vert");
  bumps_shader = loadShader("data/bumps.frag", "data/bumps.vert");

  // floor shader
  floor_shader = loadShader("data/floor.frag", "data/floor.vert");
}

void draw() {
  background(0);

  // control the scene rotation via the current mouse location
  if (!locked) {
    dirY = (mouseY / float(height) - 0.5) * 2;
    dirX = (mouseX / float(width) - 0.5) * 2;
  }

  // if the mouse is pressed, update the x and z camera locations
  if (mousePressed) {
    offsetY += (mouseY - pmouseY);
    offsetX += (mouseX - pmouseX);
  }

  // create a single directional light
  directionalLight(204, 204, 204, 0, 0, -1);

  // translate and rotate all objects to simulate a camera
  // NOTE: processing +y points DOWN
  translate(offsetX, offsetY, zoom);
  rotateY(-dirX * 1.5);
  rotateX(dirY);
  
  // Render a floor plane with the default shader
  shader(floor_shader);
  beginShape();
  vertex(-300, 300, -400);
  vertex( 300, 300, -400);
  vertex( 300, 300, 200);
  vertex(-300, 300, 200);
  endShape();

  // Render the fractal shader
  shader(fractal_shader);
  // time-varying parameters for c = (cx,cy)
  fractal_shader.set ("cx", 0.0);
  fractal_shader.set ("cy", cos(time) * 0.65);
  textureMode(NORMAL);
  beginShape();
  vertex(50, 50, -300, 0, 0);
  vertex(300, 50, -300, 1, 0);
  vertex(300, 300, -300, 1, 1);
  vertex(50, 300, -300, 0, 1);
  endShape();

  // Render the image manipulation shader
  shader(image_manip_shader);
  textureMode(NORMAL);
  beginShape();
  texture(duck_texture);
  vertex(-300, 50, 100, 0, 0);
  vertex(-50, 50, 100, 1, 0);
  vertex(-50, 300, 100, 1, 1);
  vertex(-300, 300, 100, 0, 1);
  endShape();

  shader(bumps_shader);
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 50; j++) {
      beginShape();
      texture(bumps_texture);
      vertex(-300.0 + i * 5.0, 50.0 + j * 5.0, -300.0, i / 50.0, j / 50.0);
      vertex(-300.0 + (i + 1) * 5.0, 50.0 + j * 5.0, -300.0, (i + 1) / 50.0, j / 50.0);
      vertex(-300.0 + (i + 1) * 5.0, 50.0 + (j + 1) * 5.0, -300.0, (i + 1) / 50.0, (j + 1) / 50.0);
      vertex(-300.0 + i * 5.0, 50.0 + (j + 1) * 5.0, -300.0, i / 50.0, (j + 1) / 50.0);
      endShape();
    }
  }

  // Render the circles shader
  shader(circle_shader);
  beginShape();
  vertex(50, 50, 100, 0, 0);
  vertex(300, 50, 100, 1, 0);
  vertex(300, 300, 100, 1, 1);
  vertex(50, 300, 100, 0, 1);
  endShape();

  // update the time variable
  time += 0.01;
}

void keyPressed() { if (key == ' ') locked = !locked; }

void mouseWheel(MouseEvent event) { zoom += event.getAmount() * 12.0; }
