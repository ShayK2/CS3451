// Akshay Karthik - CS 3451 Project 1B

void persp_initials() {
  gtInitialize();
  
  gtPerspective (60.0, 1.0, 100.0);

  gtPushMatrix();
  
  gtTranslate (0.0, 0.0, -4.0);
  gtRotateZ(-15);
  gtRotateX(-45);
  gtRotateY(20);
  
  gtBeginShape();

  gtVertex (-1.0, -1.0,  1.0);
  gtVertex (-0.5,  1.0,  1.0);

  gtVertex (-0.5,  1.0,  1.0);
  gtVertex ( 0, -1.0,  1.0);

  gtVertex ( 0,  -1.0,  1.0);
  gtVertex ( 0, 1.0,  1.0);

  gtVertex ( 1.0, 1.0,  1.0);
  gtVertex (0, 0,  1.0);

  gtVertex (1.0, -1.0, 1.0);
  gtVertex (0, 0, 1.0);

  gtVertex (-0.75,  0, 1.0);
  gtVertex (-0.25,  0, 1.0);

  gtEndShape();
  
  gtPopMatrix();
}
