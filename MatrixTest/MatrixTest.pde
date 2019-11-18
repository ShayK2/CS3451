// Matrix Commands

void setup() {
  size (100, 100);
  mat_test();
}

void mat_test() {
 
  println ("test 1");
  gtInitialize();
  print_ctm();
    
  println ("test 2");
  gtInitialize();
  gtTranslate(3,2,1.5);
  print_ctm();

  println ("test 3");
  gtInitialize();
  gtScale(2,3,4);
  print_ctm();

  println ("test 4");
  gtInitialize();
  gtRotateX(90);
  print_ctm();

  println ("test 5");
  gtInitialize();
  gtRotateY(-15);
  print_ctm();

  println ("test 6");
  gtInitialize();
  gtPushMatrix();
  gtRotateZ(45);
  print_ctm();
  gtPopMatrix();
  print_ctm();

  println ("test 7");
  gtInitialize();
  gtTranslate(1.5,2.5,3.5);
  gtScale(2,2,2);
  print_ctm();

  println ("test 8");
  gtInitialize();
  gtScale(4,2,0.5);
  gtTranslate(2,-2,10);
  print_ctm();

  println ("test 9");
  gtInitialize();
  gtScale(2,2,2);
  gtPushMatrix();
  gtTranslate(1.5,2.5,3.5);
  print_ctm();
  gtPopMatrix();
  print_ctm();

  println ("test 10");
  gtInitialize();
  gtPopMatrix();
}

void draw() {}
