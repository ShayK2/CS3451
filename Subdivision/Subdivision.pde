// Akshay Karthik
// CS 3451-A Project 5
// Note: Subdivisions take longer as you do more of them (more vertices to create)

import java.util.Arrays;

float time = 0;
boolean rotate, firstShape, colors, perVertex;
Mesh mesh;

void setup() {
  size(700, 700, OPENGL);
  noStroke();
}

void draw() {
  resetMatrix();
  background(0);
  perspective(PI * 0.333, 1.0, 0.01, 1000.0);
  camera(0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  ambientLight(102, 102, 102);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  fill(200, 200, 200);
  ambient(200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  rotate(time, 0.0, 1.0, 0.0);
  
  // Display the square if no shape button has been pressed yet
  if (!firstShape) {
    beginShape();
    normal(0.0, 0.0, 1.0);
    vertex(-1.0, -1.0, 0.0);
    vertex( 1.0, -1.0, 0.0);
    vertex( 1.0,  1.0, 0.0);
    vertex(-1.0,  1.0, 0.0);
    endShape(CLOSE);
  } else {
    // Draw each face
    for (int i = 0; i < mesh.V.size(); i += 3) {
      beginShape();
      
      // Give each face a random color if needed
      if (colors) {
        int[] colors = mesh.colors.get(i / 3);
        fill(colors[0], colors[1], colors[2]);
      } else fill(200, 200, 200);
      
      // perVertex --> each vertex has its own normal
      if (perVertex) {
        for (int j = 0; j < 3; j++ ) {
          Vertex vertexNormal = mesh.vertexNorms[mesh.V.get(i + j)];
          normal(vertexNormal.x, vertexNormal.y, vertexNormal.z);
          Vertex vert = mesh.G.get(mesh.V.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      } else {
        // not perVertex --> use one normal for all three vertices
        Vertex normalFace = mesh.faceNorms.get(i / 3);
        normal(normalFace.x, normalFace.y, normalFace.z);

        for (int j = 0; j < 3; j++) {
          Vertex vert = mesh.G.get(mesh.V.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      }
      
      endShape(CLOSE);
    }
  }
  
  popMatrix();

  if (rotate) time += 0.02;
}

// Turn colors off if the shape is changed, and no longer shows the square
// Toggle perVertex, colors, and rotation as desired
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply");
    firstShape = true;
    colors = false;
  } else if (key == '2') {
    read_mesh ("octa.ply");
    firstShape = true;
    colors = false;
  } else if (key == '3') {
    read_mesh ("icos.ply");
    firstShape = true;
    colors = false;
  } else if (key == '4') {
    read_mesh ("star.ply");
    firstShape = true;
    colors = false;
  } else if (key == '5') {
    read_mesh ("torus.ply");
    firstShape = true;
    colors = false;
  } else if (key == 'r') {
    colors = !colors;
    mesh.randomColors();
  } else if (key == 'n') perVertex = !perVertex;
  else if (key == 's') mesh = subdivide(mesh);
  else if (key == ' ') rotate = !rotate;
  else if (key == 'q' || key == 'Q') exit();
}

void read_mesh (String filename) {
  String[] words;
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  
  mesh = new Mesh(num_vertices, num_faces);

  for (int i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    mesh.G.add(new Vertex(float(words[0]), float(words[1]), float(words[2])));
  }
  
  for (int i = 0; i < num_faces; i++) {
    words = split (lines[i + num_vertices + 2], " ");
    
    if (int(words[0]) != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    mesh.V.add(int(words[1]));
    mesh.V.add(int(words[2]));
    mesh.V.add(int(words[3]));
  }

  // Construct data tables for the new mesh
  mesh.oTable();
  mesh.faceNorms();
  mesh.vertexNorms();
}

Mesh subdivide(Mesh old) {
  ArrayList<Integer> newV = new ArrayList<Integer>();
  ArrayList<Vertex> newG = new ArrayList<Vertex>();

  // Compute even vertices
  ArrayList<ArrayList<Integer>> adjacentVertices = adjVertices(old); // Neighbors of each vertex
  for (int i = 0; i < old.G.size(); i++) {
    // Add adjacent vertices * u + (1 - n*u) * original vertex
    ArrayList<Integer> adjVerts = adjacentVertices.get(i);
    Vertex sumOfNeighbors = new Vertex(0.0, 0.0, 0.0);
    for (int j = 0; j < adjVerts.size(); j++) sumOfNeighbors = sumOfNeighbors.add(old.G.get(adjVerts.get(j)));
    float u = adjVerts.size() == 3 ? 3.0 / 16.0 : 3.0 / (8.0 * adjVerts.size());
    newG.add(old.G.get(i).mult(1 - adjVerts.size() * u).add(sumOfNeighbors.mult(u)));
  }

  // Compute odd vertices (one for each edge of currentMesh)
  ArrayList<int[]> traversedEdges = new ArrayList<int[]>();
  int[] innerTriangleIDs = new int[3];
  int firstID = 0;
  int secondID = 0;
  
  // Go through each corner
  for (int j = 0; j < old.V.size(); j++) {
    int currentVertex = old.V.get(j);
    int nextVertex = old.V.get(next(j));
    int prevVertex = old.V.get(prev(j));

    // Construct adjacent edges, check if they have already been traversed
    int[] firstEdge = {currentVertex, nextVertex};
    Arrays.sort(firstEdge);

    int[] secondEdge = {currentVertex, prevVertex};
    Arrays.sort(secondEdge);

    boolean hasFirstEdge = false;
    boolean hasSecondEdge = false;
    
    for (int k = 0; k < traversedEdges.size(); k++) {
      int[] check = traversedEdges.get(k);
      if (check[0] == firstEdge[0] && check[1] == firstEdge[1]) hasFirstEdge = true;
      if (check[0] == secondEdge[0] && check[1] == secondEdge[1]) hasSecondEdge = true;
    }

    Vertex leftVert = old.G.get(prevVertex);
    Vertex rightVert = old.G.get(old.V.get(old.O[prev(j)]));
    
    Vertex currentVert = old.G.get(currentVertex);
    Vertex prevVert = old.G.get(prevVertex);

    Vertex newVert = currentVert.add(old.G.get(nextVertex)).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));
    
    
    // If not traversed, add the new vertex to G
    // Otherwise, note the ID of the vertex already in G
    if (!hasFirstEdge) {
      traversedEdges.add(firstEdge);
      firstID = newG.size();
      newG.add(newVert);
    } else {
      for (int k = 0; k < newG.size(); k++) {
        Vertex check = newG.get(k);
        if (check.equals(newVert)) {
          firstID = k;
          break;
        }
      }
    }
    
    leftVert = old.G.get(nextVertex);
    rightVert = old.G.get(old.V.get(old.O[next(j)]));
      
    newVert = currentVert.add(prevVert).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));

    // If not traversed, add the new vertex to G
    // Otherwise, note the ID of the vertex already in G
    if (!hasSecondEdge){
      traversedEdges.add(secondEdge);
      secondID = newG.size();
      newG.add(newVert);
    } else {      
      for (int k = 0; k < newG.size(); k++) {
        Vertex check = newG.get(k);
        if (check.equals(newVert)) {
          secondID = k;
          break;
        }
      }
    }

    // Add the vertex and its adjacent new vertices to V
    newV.add(currentVertex);
    newV.add(firstID);
    newV.add(secondID);
    
    // If all 3 corners of a triangle have been visited, add the new middle face to V
    if(j % 3 == 0) innerTriangleIDs[0] = firstID;
    else if (j % 3 == 1) innerTriangleIDs[1] = firstID;
    else {
      newV.add(innerTriangleIDs[0]);
      newV.add(innerTriangleIDs[1]);
      newV.add(firstID);
    }
  }
  
  
  // Create data tables for the new mesh
  Mesh newMesh = new Mesh(newG.size(), newV.size() / 3);
  newMesh.V = newV;
  newMesh.G = newG;
  
  newMesh.oTable();
  newMesh.faceNorms();
  newMesh.vertexNorms();  

  return newMesh;
}

// For each vertex, create a list of its neighbors by swinging around that vertex and getting the next vertex of each corner
ArrayList<ArrayList<Integer>> adjVertices(Mesh mesh) {
  ArrayList<ArrayList<Integer>> adjVertices = new ArrayList<ArrayList<Integer>>();
  boolean[] found = new boolean[mesh.G.size()];

  for (int i = 0; i < mesh.G.size(); i++) adjVertices.add(new ArrayList<Integer>());

  for (int i = 0; i < mesh.V.size(); i++) {
    if (found[mesh.V.get(i)] == false) {
      ArrayList<Integer> vertices = new ArrayList<Integer>();
      vertices.add(mesh.V.get(next(i)));
      int swing = mesh.swing(i);

      while(swing != i) {
        vertices.add(mesh.V.get(next(swing)));
        swing = mesh.swing(swing);
      }
      
      found[mesh.V.get(i)] = true;
      adjVertices.set(mesh.V.get(i), vertices);
    }
  }
  
  return adjVertices;
}

// Calculate the next and previous index of a given index in V
int next(int corner) { return (corner / 3) * 3 + (corner + 1) % 3; }

int prev(int corner) { return next(next(corner)); }

class Mesh {
  ArrayList<Integer> V;
  ArrayList<Vertex> G, faceNorms;
  int[] O;
  ArrayList<int[]> colors;
  Vertex[] vertexNorms;
  int num_vertices, num_faces;

  Mesh(int v, int f) {
    V = new ArrayList<Integer>();
    G = new ArrayList<Vertex>();
    O = new int[3 * f];
    faceNorms = new ArrayList<Vertex>();
    vertexNorms = new Vertex[v];
    colors = new ArrayList<int[]>();
    num_vertices = v; num_faces = f;
  }
  
  // Swing to the next corner that shares a vertex
  int swing(int corner) { return next(O[next(corner)]); }
  
  // Create O by comparing all vertices to each other to see if their next/prev match each other
  void oTable() {
    for (int a = 0; a < V.size(); a++) {
      for (int b = 0; b < V.size(); b++) {
        if (V.get(next(a)).equals(V.get(prev(b))) && V.get(prev(a)).equals(V.get(next(b)))) {
          O[a] = b;
          O[b] = a;
        }
      }
    }
  }
  
  // Find the normal of each face by crossing two vectors
  void faceNorms() { for (int i = 0; i < V.size(); i += 3) faceNorms.add(faceNorm(G.get(V.get(i)), G.get(V.get(i + 1)), G.get(V.get(i + 2)))); }

  Vertex faceNorm(Vertex a, Vertex b, Vertex c) { return b.sub(a).cross(c.sub(a)).norm(); }
  
  // Find the normal of each vertex by averaging together the normal of all faces the vertex is part of
  void vertexNorms() {
    boolean[] normalized = new boolean[G.size()];

    for (int i = 0; i < V.size(); i++) {
      if (normalized[V.get(i)] == false) {
        Vertex vertNormal = faceNorms.get(i / 3);
        int swing = swing(i);
        while(swing != i) {
          vertNormal = vertNormal.add(faceNorms.get(swing / 3));
          swing = swing(swing);
        }
        
        vertexNorms[V.get(i)] = vertNormal.norm();
        normalized[V.get(i)] = true;
      }
    }
  }

  // Create a random color to fill the face with
  void randomColors() {
    colors = new ArrayList<int[]>();
    for (int j = 0; j < num_faces; j++) colors.add(new int[]{(int) random(0, 256), (int) random(0, 256), (int) random(0, 256)});
  }
}

// Store a triple of values representing a vertex, and various functions to manipulate vectors
class Vertex {
  float x, y, z;

  Vertex(float x, float y, float z) { this.x = x; this.y = y; this.z = z; }

  Vertex sub(Vertex second) { return new Vertex(x - second.x, y - second.y, z - second.z); }

  Vertex add(Vertex second) { return new Vertex(x + second.x, y + second.y, z + second.z); }

  Vertex cross(Vertex second) { return new Vertex(y * second.z - z * second.y, z * second.x - x * second.z, x * second.y - y * second.x); }

  Vertex norm() { return new Vertex(x / sqrt(x * x + y * y + z * z), y / sqrt(x * x + y * y + z * z), z / sqrt(x * x + y * y + z * z)); }
  
  Vertex mult(float scale) { return new Vertex(x * scale, y * scale, z * scale); }
  
  boolean equals(Vertex other) { return x == other.x && y == other.y && z == other.z; }
}
