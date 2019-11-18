// Akshay Karthik - Project 2B

// Instancing: Drawers, laptops, bottles

float time = 0;

void setup() {
  size(800, 800, P3D);  // must use 3D here
  noStroke();           // do not draw the edges of polygons
}

void draw() {
  resetMatrix();  // set the transformation matrix to the identity
  background(0, 0, 255);  // clear the screen to blue

  // set up for perspective projection
  perspective (PI * 0.333, 1, 0.01, 1000);

  // place the camera in the scene (just like gluLookAt())
  camera (0, -150 + time * 15, 275, 0, 0, -1, 0, 1, 0);

  // create light sources
  ambientLight (102, 102, 102);
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);

  // sphereDetail (40);
  // sphere (13);

  fill (65, 41, 0); // "fill" sets both diffuse and ambient color
  ambient (30, 30, 30); // set ambient color
  specular (0, 0, 0); // set specular color
  shininess (4); // set specular exponent
  
  translate(-25, 0, 0);
  rotateY(PI / 9);

  pushMatrix();
  fill(40);
  translate(25, 95, 0);
  box(400, 170, 30);
  translate(0, 50, 40);
  fill(255);
  box(400, 20, 80);
  fill (65, 41, 0);
  popMatrix();

  pushMatrix();
   // desk tumbles off of cliff, lands on platform
   if (time < 5) translate(0, 0, time * 5);
   else if (time < 4 * PI + 5) {
     translate(0, (time - 5) * 10, 25 + (time - 5) * 2.75);
     rotateX(-1.5 * (time - 5));
   } else translate(0, 40 * PI, 25 + 11 * PI);
   
   desk();
   
   pushMatrix();
   translate(-40, -40, -10);
   bottle(2);
   popMatrix();
   
   pushMatrix();
   translate(-20, -40, -10);
   bottle(4);
   popMatrix();
   
   pushMatrix();
   laptop(10, 5, -35);
   popMatrix();
   
   pushMatrix();
   laptop(10, 5, -5);
   popMatrix();
   
  popMatrix();

  time += 0.03;
  
  if (time > 18) background(0, 0, 0);
}

void desk() {
  // left leg and frame
  box (2, 20, 20);
  translate(2, 0, -9);
  box (2, 20, 2);
  translate(0, 0, 18);
  box (2, 20, 2);
  translate(13, 4, -14);
  box(29, 4, 2);
  
  // keyboard drawer
  pushMatrix();
  if (time > 5 && time < 4 * PI + 5) translate(-10.2, -11.75, 10 + sin(time) * 4);
  else translate(-10.2, -11.75, 10);
  scale(1.28, 0.2, 0.8);
  drawer();
  popMatrix();
  
  // surface
  translate (9, -15, 5);
  fill (95, 60, 0);
  box (55, 2, 20);
  fill (65, 41, 0);
  
  // right and middle legs
  translate (24, 11, 0);
  box (2, 20, 20);
  translate(-17.5, 0, 0);
  box (2, 20, 20);
  
  // back wall
  translate(8.75, 0, -9);
  box(15.5, 20, 2);
  
  // drawers
  translate(-6.75, 5, 10.25);
  scale(0.75, 0.25, 0.75);
  pushMatrix();
  translate(0, 0, sin(time) * 4);
  drawer();
  popMatrix();
  translate(0, -24, 0);
  pushMatrix();
  translate(0, 0, sin(time - 3) * 4);
  drawer();
  popMatrix();
  translate(0, -24, 0);
  pushMatrix();
  translate(0, 0, sin(time - 6) * 4);
  drawer();
  popMatrix();
}

// drawer with an open top and handle
void drawer() {
  pushMatrix();
  
  box (2, 20, 20);
  translate(18, 0, 0);
  box (2, 20, 20);
  translate(-9, 11, 0);
  box(20, 2, 20);
  translate(0, -10, -11);
  box(20, 22, 2);
  translate(0, 0, 22);
  box(20, 22, 2);
  rotateX(PI / 2);
  
  scale(0.8, 1, 1);
  handle();
  
  popMatrix();
}

void handle() {
  fill(0, 0, 0);
  cylinder(1, 3, 32);
  translate(0, 3, 0);
  sphere(1.5);
  fill(65, 41, 0);
}

void bottle(int rotationSpeed) {
  scale(0.5, 1, 0.5);
  if (time > 5 && time < 4 * PI + 5) {
     rotateX(rotationSpeed * (time - 5));
     rotateZ(rotationSpeed * (time - 5));
  }
  fill(80);
  cylinder(4, 20, 32);
  sphere(4);
  cylinder(1, -6, 32);
  fill (65, 41, 0);
}

// laptops fly off the desk & close, then settle back down once the desk lands
void laptop(int startClose, int delay, int trans) {
  if (time < 5 || time >= 4 * PI + 5) translate(trans, -22.5, 0);
  else {
    float x = 10 * abs(2 * PI + 5 - time) / PI;
    translate(trans, -42.5 + x, 0);
  }
   
  scale(1, 3, 1);
  fill(80);
  box(10, 1, 6);
  
  // close screen of laptop after time delay
  if (time <= delay) {
    translate(0, -3, -2);
    rotateX(PI / 3);
  } else if (time  > startClose + delay) translate(0, -1, 0);
  else {
    translate(0, -3 + 2 * (time - delay) / startClose, -2 + (time - delay) * 2 / startClose);
    rotateX(PI / 3 - (time - delay) * PI / (3 * startClose));
  }
  box(10, 1, 6);
  fill (65, 41, 0);
}

// draw a cylinder of a given radius, height and number of sides.
// the base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  float []c = new float[sides];
  float []s = new float[sides];

  for (int i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  normal (0.0, -1.0, 0.0);
  for (int i = 0; i < sides; i++) {
    beginShape(TRIANGLES);
    vertex (c[(i+1) % sides] * radius, 0.0, s[(i+1) % sides] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap
  normal (0.0, 1.0, 0.0);
  for (int i = 0; i < sides; i++) {
    beginShape(TRIANGLES);
    vertex (c[(i+1) % sides] * radius, height, s[(i+1) % sides] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (int i = 0; i < sides; i++) {
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[(i+1) % sides], 0.0, s[(i+1) % sides]);
    vertex (c[(i+1) % sides] * radius, height, s[(i+1) % sides] * radius);
    vertex (c[(i+1) % sides] * radius, 0.0, s[(i+1) % sides] * radius);
    endShape(CLOSE);
  }
}
