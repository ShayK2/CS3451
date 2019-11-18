// Akshay Karthik - CS 3451 Project 1B

// Store transformations, vertices, and orthogonal/perspective transformation
private ArrayList<float[][]> stack;
private ArrayList<float[]> vertices;
private float[] modifier;

void gtInitialize() {
  // Initialize ArrayList, then add 2D array for identity matrix
  stack = new ArrayList<float[][]>();
  stack.add(new float[][]{{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}});
}

float[] vertexMultiply(float[][] matrix, float[] vertex) {
  // Multiply each row of the matrix with the elements of the vertex
  float[] result = new float[vertex.length];
  for (int i = 0; i < result.length; i++) {
    result[i] = matrix[i][0] * vertex[0] + matrix[i][1] * vertex[1] + matrix[i][2] * vertex[2] + matrix[i][3];
  }
  return result;
}

float[][] multiply(float[][] left, float[][] right) {
  float[][] result = new float[left.length][right[0].length];
  
  // Each entry is the product of the corresponding row of left and col of right
  for (int i = 0; i < result.length; i++) {
    for (int j = 0; j < result[0].length; j++) {
      result[i][j] = left[i][0] * right[0][j] + left[i][1] * right[1][j] + left[i][2] * right[2][j] + left[i][3] * right[3][j];
    }
  }
  return result;
}

void gtPushMatrix() {
  // Copy the top entry, then add it
  float[][] copy = stack.get(stack.size() - 1);
  stack.add(copy);
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

void gtPerspective(float fov, float near, float far) {
  // Set the modifier to the input parameters
  modifier = new float[]{fov * PI / 180, near, far};
}

void gtOrtho(float left, float right, float bottom, float top, float near, float far) {
  // Set the modifier to the input parameters
  modifier = new float[]{left, right, bottom, top, near, far};
}

void gtBeginShape() {
  // Initialize vertex list
  vertices = new ArrayList<float[]>();
}

void gtVertex(float x, float y, float z) {
  // Add input to vertex list
  vertices.add(new float[]{x, y, z});
}

void gtEndShape() {
  for (int i = 0; i < vertices.size() - 1; i+= 2) {
    // Get the next pair of vertices to connect
    float[] v1 = vertexMultiply(stack.get(stack.size() - 1), vertices.get(i));
    float[] v2 = vertexMultiply(stack.get(stack.size() - 1), vertices.get(i + 1));
    float x1, y1, x2, y2;
    if (modifier.length == 6) {
      // If the transformation is orthogonal, use the appropriate formula on each coordinate
      x1 = (v1[0] - modifier[0]) * width / (modifier[1] - modifier[0]);
      y1 = (v1[1] - modifier[2]) * height / (modifier[3] - modifier[2]);
      x2 = (v2[0] - modifier[0]) * width / (modifier[1] - modifier[0]);
      y2 = (v2[1] - modifier[2]) * height / (modifier[3] - modifier[2]);
    } else {
      // If the transformation is perspective, use the appropriate formula on each coordinate
      float k = tan(modifier[0] / 2);
      x1 = (v1[0] / abs(v1[2]) + k) * width / (2 * k);
      y1 = (v1[1] / abs(v1[2]) + k) * height / (2 * k);
      x2 = (v2[0] / abs(v2[2]) + k) * width / (2 * k);
      y2 = (v2[1] / abs(v2[2]) + k) * height / (2 * k);
    }
    line(x1, height - y1, x2, height - y2);
  }
}
