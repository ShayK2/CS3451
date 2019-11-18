// Akshay Karthik

// Store transformations in an ArrayList
private ArrayList<float[][]> stack;

void gtInitialize() {
  // Initialize ArrayList, then add 2D array for identity matrix
  stack = new ArrayList<float[][]>();
  float[][] identity = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  stack.add(identity);
}

float[][] multiply(float[][] left, float[][] right) {
  float[][] result = new float[4][4];
  
  // Each entry is the product of the corresponding row of left and col of right
  for (int i = 0; i < result.length; i++) for (int j = 0; j < result[0].length; j++) result[i][j] = left[i][0] * right[0][j] + left[i][1] * right[1][j] + left[i][2] * right[2][j] + left[i][3] * right[3][j];
  return result;
}

void gtPushMatrix() {
  // Copy the top entry, then add it
  stack.add(stack.get(stack.size() - 1));
}

void gtPopMatrix() {
  // If the stack is empty, error; else, remove the top element
  if (stack.size() == 1) {
    print("Error: Stack is empty.");
    return;
  }
  stack.remove(stack.size() - 1); 
}

void gtTranslate(float x, float y, float z) {
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{1, 0, 0, x}, {0, 1, 0, y}, {0, 0, 1, z}, {0, 0, 0, 1}};
  stack.set(stack.size() - 1, multiply(stack.get(stack.size() - 1), matrix)); 
}

void gtScale(float x, float y, float z) {
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{x, 0, 0, 0}, {0, y, 0, 0}, {0, 0, z, 0}, {0, 0, 0, 1}};
  stack.set(stack.size() - 1, multiply(stack.get(stack.size() - 1), matrix)); 
}

void gtRotateX(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{1, 0, 0, 0}, {0, cos(theta), -sin(theta), 0}, {0, sin(theta), cos(theta), 0}, {0, 0, 0, 1}};
  stack.set(stack.size() - 1, multiply(stack.get(stack.size() - 1), matrix)); 
}

void gtRotateY(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{cos(theta), 0, sin(theta), 0}, {0, 1, 0, 0}, {-sin(theta), 0, cos(theta), 0}, {0, 0, 0, 1}};
  stack.set(stack.size() - 1, multiply(stack.get(stack.size() - 1), matrix)); 
}

void gtRotateZ(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{cos(theta), -sin(theta), 0, 0}, {sin(theta), cos(theta), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  stack.set(stack.size() - 1, multiply(stack.get(stack.size() - 1), matrix)); 
}

void print_ctm() {
  float[][] top = stack.get(stack.size() - 1);
  
  // Loop through each row and print out the elements separated by commas
  for (int i = 0; i < top.length; i++) {
    String line = "[";
    for (int j = 0; j < top[i].length; j++) {
      line += top[i][j];
      if (j != top[i].length - 1) line += ", ";
    }
    line += "]";
    println(line);
  }
}
