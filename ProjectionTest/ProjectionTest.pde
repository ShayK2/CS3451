// CS 3451 Homework
// main program file

void setup() {
  size(500, 500);
  background (255, 255, 255);
}

void draw() {
  // unused in this program because we only want to draw based on keyboard input
}

/******************************************************************************
When key is pressed, call one of the drawing test cases.
******************************************************************************/

void keyPressed() {
  
  stroke (0, 0, 0);
  background (255, 255, 255);

  if (key == '1') { ortho_test(); }
  if (key == '2') { ortho_test_scale(); }
  if (key == '3') { ortho_test_rotate(); }
  if (key == '4') { face_test(); }
  if (key == '5') { faces(); }
  if (key == '6') { ortho_cube(); }
  if (key == '7') { ortho_cube2(); }
  if (key == '8') { perspective_cube(); }
  if (key == '9') { persp_multi_cube(); }
  if (key == '0') { persp_initials(); }
}

/******************************************************************************
Print where the mouse was clicked, possibly useful for debugging.
******************************************************************************/

void mousePressed() {
  if (mouseButton == LEFT) { println("you clicked on pixel ("+mouseX+", "+mouseY+")"); }
}

/******************************************************************************
Test square drawing.
******************************************************************************/

void ortho_test()
{
  float nnear = -10.0;
  float ffar = 40.0;

  gtInitialize();
  gtOrtho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  square();
}

/******************************************************************************
Test square drawing with non-uniform scaling.
******************************************************************************/

void ortho_test_scale()
{
  float nnear = -10.0;
  float ffar = 40.0;

  gtInitialize();
  gtOrtho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  gtScale (1.0, 0.5, 1.0);
  square();
}

/******************************************************************************
Test square drawing with rotation.
******************************************************************************/

void ortho_test_rotate()
{
  float nnear = -10.0;
  float ffar = 40.0;

  gtInitialize();
  gtOrtho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  gtRotateZ (20);
  square();
}

/******************************************************************************
Draw a square.
******************************************************************************/

void square()
{
  gtBeginShape();
  
  gtVertex (-50.0, -50.0, 0.0);
  gtVertex (-50.0,  50.0, 0.0);

  gtVertex (-50.0, 50.0, 0.0);
  gtVertex ( 50.0, 50.0, 0.0);

  gtVertex (50.0, 50.0, 0.0);
  gtVertex (50.0, -50.0, 0.0);

  gtVertex (50.0, -50.0, 0.0);
  gtVertex (-50.0, -50.0, 0.0);

  gtEndShape();
}

/******************************************************************************
Draw a cube.
******************************************************************************/

void cube()
{
  gtBeginShape();

  /* top square */

  gtVertex (-1.0, -1.0,  1.0);
  gtVertex (-1.0,  1.0,  1.0);

  gtVertex (-1.0,  1.0,  1.0);
  gtVertex ( 1.0,  1.0,  1.0);

  gtVertex ( 1.0,  1.0,  1.0);
  gtVertex ( 1.0, -1.0,  1.0);

  gtVertex ( 1.0, -1.0,  1.0);
  gtVertex (-1.0, -1.0,  1.0);

  /* bottom square */

  gtVertex (-1.0, -1.0, -1.0);
  gtVertex (-1.0,  1.0, -1.0);

  gtVertex (-1.0,  1.0, -1.0);
  gtVertex ( 1.0,  1.0, -1.0);

  gtVertex ( 1.0,  1.0, -1.0);
  gtVertex ( 1.0, -1.0, -1.0);

  gtVertex ( 1.0, -1.0, -1.0);
  gtVertex (-1.0, -1.0, -1.0);

  /* connect top to bottom */

  gtVertex (-1.0, -1.0, -1.0);
  gtVertex (-1.0, -1.0,  1.0);

  gtVertex (-1.0,  1.0, -1.0);
  gtVertex (-1.0,  1.0,  1.0);

  gtVertex ( 1.0,  1.0, -1.0);
  gtVertex ( 1.0,  1.0,  1.0);

  gtVertex ( 1.0, -1.0, -1.0);
  gtVertex ( 1.0, -1.0,  1.0);

  gtEndShape();
}

/******************************************************************************
Orthographic cube.
******************************************************************************/

void ortho_cube()
{
  gtInitialize();
    
  gtOrtho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, 4.0);
  gtRotateY(17.0);
  cube();
  gtPopMatrix();
}

/******************************************************************************
Orthographic cube rotated.
******************************************************************************/

void ortho_cube2()
{
  gtInitialize();
    
  gtOrtho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  gtRotateZ(5.0);
  gtRotateX(25.0);
  gtRotateY(20.0);
  cube();
  gtPopMatrix();
}

/******************************************************************************
Perspective cube.
******************************************************************************/

void perspective_cube()
{
  gtInitialize();
  gtPerspective (60.0, 1.0, 100.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -4.0);
  cube();
  gtPopMatrix();
}

/******************************************************************************
Draw multiple cubes in perspective.
******************************************************************************/

void persp_multi_cube()
{
  gtInitialize();
  gtPerspective (60.0, 1.0, 100.0);

  gtPushMatrix();
  gtTranslate (0.0, 0.0, -20.0);
  gtRotateZ(5);
  gtRotateX(25);
  gtRotateY(20);

  // draw several cubes in three lines along the axes
  for (float delta = -12; delta <= 12; delta += 3) {
    gtPushMatrix();
    gtTranslate(delta, 0, 0);
    cube();
    gtPopMatrix();
    gtPushMatrix();
    gtTranslate(0, delta, 0);
    cube();
    gtPopMatrix();
    gtPushMatrix();
    gtTranslate(0, 0, delta);
    cube();
    gtPopMatrix();
  }

  gtPopMatrix();
}

/******************************************************************************
Draw a circle of unit radius.
******************************************************************************/

void circle()
{
  int i;
  float theta;
  float x0,y0,x1,y1;
  float steps = 50;

  gtBeginShape();

  x0 = 1.0;
  y0 = 0.0;
  for (i = 0; i <= steps; i++) {
    theta = 2 * 3.1415926535 * i / steps;
    x1 = cos (theta);
    y1 = sin (theta);
    gtVertex (x0, y0, 0.0);
    gtVertex (x1, y1, 0.0);
    x0 = x1;
    y0 = y1;
  }

  gtEndShape();
}

/******************************************************************************
Draw a face.
******************************************************************************/

void face()
{
  /* head */

  gtPushMatrix();
  gtTranslate (0.5, 0.5, 0.0);
  gtScale (0.4, 0.4, 1.0);
  circle();
  gtPopMatrix();

  /* right eye */

  gtPushMatrix();
  gtTranslate (0.7, 0.7, 0.0);
  gtScale (0.1, 0.1, 1.0);
  circle();
  gtPopMatrix();

  /* left eye */

  gtPushMatrix();
  gtTranslate (0.3, 0.7, 0.0);
  gtScale (0.1, 0.1, 1.0);
  circle();
  gtPopMatrix();

  /* nose */

  gtPushMatrix();
  gtTranslate (0.5, 0.5, 0.0);
  gtScale (0.07, 0.07, 1.0);
  circle();
  gtPopMatrix();

  /* mouth */

  gtPushMatrix();
  gtTranslate (0.5, 0.25, 0.0);
  gtScale (0.2, 0.1, 1.0);
  circle();
  gtPopMatrix();
}

/******************************************************************************
Test the matrix stack by drawing a face.
******************************************************************************/

void face_test()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  gtInitialize ();

  gtOrtho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  face();
}

/******************************************************************************
Draw four faces.
******************************************************************************/

void faces()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  gtInitialize ();

  gtOrtho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  gtPushMatrix();
  gtTranslate (0.75, 0.25, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.25, 0.25, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.75, 0.75, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();

  gtPushMatrix();
  gtTranslate (0.25, 0.75, 0.0);
  gtScale (0.5, 0.5, 1.0);
  gtRotateZ (30.0);
  gtTranslate (-0.5, -0.5, 0.0);
  face();
  gtPopMatrix();
}
