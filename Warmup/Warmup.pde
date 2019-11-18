void setup() {
  size(500, 500);
  noStroke();
  background(0, 0, 160);
}

void draw() {
  fill(0, 160, 0);
  ellipse(width / 2, height / 2, width, height);
  drawCircle(width / 2, height / 2, width / 2, 9);
}

void drawCircle(float xCenter, float yCenter, float radius, int depth) {                    
  float theta = mouseX * PI / (height / 2);
  float newRad = 0.7 * radius * (height - mouseY) / height;
  fill(0, 120 * (1 - depth % 2), 120 * (depth % 2));
  ellipse(xCenter + sin(theta) * (radius - newRad), yCenter - cos(theta) * (radius - newRad), newRad * 2, newRad * 2);
  ellipse(xCenter + sin(theta + 2 * PI / 3) * (radius - newRad), yCenter - cos(theta + 2 * PI / 3) * (radius - newRad), newRad * 2, newRad * 2);
  ellipse(xCenter + sin(theta + 4 * PI / 3) * (radius - newRad), yCenter - cos(theta + 4 * PI / 3) * (radius - newRad), newRad * 2, newRad * 2);
  if(depth > 1) {
    drawCircle(xCenter + sin(theta) * (radius - newRad), yCenter - cos(theta) * (radius - newRad), newRad, depth - 1);
    drawCircle(xCenter + sin(theta + 2 * PI / 3) * (radius - newRad), yCenter - cos(theta + 2 * PI / 3) * (radius - newRad), newRad, depth - 1);
    drawCircle(xCenter + sin(theta + 4 * PI / 3) * (radius - newRad), yCenter - cos(theta + 4 * PI / 3) * (radius - newRad), newRad, depth - 1);
  }
}
