// Akshay Karthik
// CS 3451-A Project 3B

void setup() {
  size(400, 400);  
  noStroke();
  colorMode(RGB);
  background(0, 0, 0);
}

// Global variables
float fov;
float[][] uvw = new float[3][3];
float[] surface = new float[11];
ArrayList<Light> lights = new ArrayList<Light>();
ArrayList<Sphere> spheres = new ArrayList<Sphere>();
ArrayList<Cone> cones = new ArrayList<Cone>();
PVector background, eye = new PVector(0, 0, 0);

// Reset global variables to their default values
void reset_scene() {
  lights = new ArrayList<Light>();
  spheres = new ArrayList<Sphere>();
  cones = new ArrayList<Cone>();
  surface = new float[11];
  uvw = new float[3][3];
  fov = 0.0;
  background = new PVector(0, 0, 0);
  eye = new PVector(0, 0, 0);
}

void keyPressed() {
  reset_scene();
  switch(key) {
    case '1':  interpreter("01_one_sphere.cli"); break;
    case '2':  interpreter("02_three_spheres.cli"); break;
    case '3':  interpreter("03_shiny_sphere.cli"); break;
    case '4':  interpreter("04_one_cone.cli"); break;
    case '5':  interpreter("05_more_cones.cli"); break;
    case '6':  interpreter("06_ice_cream.cli"); break;
    case '7':  interpreter("07_colorful_lights.cli"); break;
    case '8':  interpreter("08_reflective_sphere.cli"); break;
    case '9':  interpreter("09_mirror_spheres.cli"); break;
    case '0':  interpreter("10_reflections_in_reflections.cli"); break;
    case 'q':  exit(); break;
  }
}

// Construct appropriate objects from parsing cli file
void interpreter(String filename) {
  println("Parsing '" + filename + "'");
  String str[] = loadStrings(filename);
  if (str == null) println("Error! Failed to read the file.");
  for (int i = 0; i < str.length; i++) {
    String[] token = splitTokens(str[i], " ");
    if (token.length == 0) continue;
    if (token[0].equals("fov")) fov = float(token[1]);
    else if (token[0].equals("background")) background = new PVector(float(token[1]), float(token[2]), float(token[3]));
    else if (token[0].equals("eye")) eye = new PVector(float(token[1]), float(token[2]), float(token[3]));
    else if (token[0].equals("uvw")) uvw = new float[][]{{float(token[1]), float(token[2]), float(token[3])},
        {float(token[4]), float(token[5]), float(token[6])},
        {float(token[7]), float(token[8]), float(token[9])}};
    else if (token[0].equals("light")) lights.add(new Light(new PVector(float(token[1]), float(token[2]), float(token[3])), new PVector(float(token[4]), float(token[5]), float(token[6]))));
    else if (token[0].equals("surface"))
      for (int j = 0; j < surface.length; j++) {
        surface[j] = float(token[j + 1]);
      }
    else if (token[0].equals("sphere")) spheres.add(new Sphere(float(token[1]), new PVector(float(token[2]), float(token[3]), float(token[4])), new PVector(surface[0], surface[1], surface[2]), new PVector(surface[3], surface[4], surface[5]), new PVector(surface[6], surface[7], surface[8]), surface[9], surface[10]));
    else if (token[0].equals("cone")) cones.add(new Cone(new PVector(float(token[1]), float(token[2]), float(token[3])), float(token[4]), float(token[5]), new PVector(surface[0], surface[1], surface[2]), new PVector(surface[3], surface[4], surface[5]), new PVector(surface[6], surface[7], surface[8]), surface[9], surface[10]));
    else if (token[0].equals("write")) {
      draw_scene();
      println("Saving image to '" + token[1] + "'");
      save(token[1]);
    } else if (token[0].equals("#")) {
    } else println ("cannot parse line: " + str[i]);
  }
}

// Classes to store data for different objects as well as Hits, light sources, and rays

abstract class Object {
  PVector location, diffuse, ambient, specular;
  float P, Krefl;
}

class Sphere extends Object {
  float radius;
  
  public Sphere(float r, PVector loc, PVector diff, PVector amb, PVector spec, float P, float K) {
    radius = r; this.P = P; Krefl = K; location = loc; diffuse = diff; ambient = amb; specular = spec;
  }
}

class Cone extends Object {
  float h, wideFactor;
  
  public Cone(PVector loc, float h, float k, PVector diff, PVector amb, PVector spec, float P, float K) {
    location = loc; this.h = h; wideFactor = k; diffuse = diff; ambient = amb; specular = spec; this.P = P; Krefl = K;
  }
}

class Hit {
  Object shape;
  float root;
  PVector intersection, normal;
  Ray ray;
  
  public Hit(Object object, float t, PVector point, PVector norm, Ray ray) {
    shape = object; root = t; intersection = point; normal = norm; this.ray = ray;
  }
}

class Light {
  PVector location, colors;
  
  public Light(PVector loc, PVector c) {
    location = loc; colors = c;
  }
}

class Ray {
  PVector origin, direction;
  
  public Ray(PVector eye, PVector dir) {
    origin = eye; direction = dir;
  }
}

void draw_scene() {
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      // Calculate the direction vector for this pixel
      float d = 1.0 / tan(radians(fov / 2.0));
      float u = (2.0 * x / width) - 1.0;
      float v = (2.0 * (height - y) / height) - 1.0;
      PVector direction = new PVector(-d * uvw[2][0] + u * uvw[0][0] + v * uvw[1][0], -d * uvw[2][1] + u * uvw[0][1] + v * uvw[1][1], -d * uvw[2][2] + u * uvw[0][2] + v * uvw[1][2]);
      
      // Use intersection to find if there is a hit with this ray, calculate its color (background or otherwise), and fill the pixel with that color
      PVector final_color = calculateColor(intersection(new Ray(eye, direction), null), 1);
      fill(final_color.x * 255.0, final_color.y * 255.0, final_color.z * 255.0);
      rect(x, y, 1, 1);
    }
  }
}

Hit intersection(Ray ray, Light light) {
      Sphere nearestSphere = new Sphere(0, new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), 0, 0);
      float minRoot = Float.MAX_VALUE;
      Hit hit = null;
      if (light != null) {
        PVector l = PVector.sub(light.location, ray.origin);
        minRoot = sqrt(l.dot(l));
      }

      // Calculate roots for spheres
      for (Sphere shape: spheres) {
        float a = ray.direction.dot(ray.direction);
        PVector delta = PVector.sub(ray.origin, shape.location);
        float b = 2 * PVector.dot(ray.direction, PVector.sub(ray.origin, shape.location));
        float c = PVector.dot(delta, delta) - pow(shape.radius, 2);

        float determinant = pow(b, 2) - (4 * a * c);
        float t_max = 0.0;
        if (determinant > 0) {
          float[] roots = {( -1 * b + sqrt(determinant) ) / (2 * a), ( -1 * b - sqrt(determinant) ) / (2 * a)};
          if (roots[0] > 0 && roots[1] > 0) t_max = roots[0] < roots[1] ? roots[0] : roots[1];
          else if (roots[0] < 0 && roots[1] > 0) t_max = roots[1];
          else if (roots[0] > 0 && roots[1] < 0) t_max = roots[0];
          else t_max = 0.0;

          if (t_max > 0.0 && t_max < minRoot) {
            minRoot = t_max;
            nearestSphere = shape;
            PVector hitOrigin = PVector.add(ray.origin, PVector.mult(ray.direction, minRoot));
            PVector hitNormal = PVector.sub(hitOrigin, nearestSphere.location).normalize();
            hit = new Hit(nearestSphere, minRoot, hitOrigin, hitNormal, ray);
          }
        }
      }

      // Calculate roots for cones, including cap and round body
      for (Cone shape: cones) {
        //Cap intersection
        float t = (shape.location.y + shape.h) / ray.direction.y;
        float newX = ray.origin.x + ray.direction.x * t;
        float newZ = ray.origin.z + ray.direction.z * t;

        if (t > 0) {
          float distance = sqrt( pow(newX - shape.location.x, 2) + pow(newZ - shape.location.z, 2));
          if (distance <= shape.h * shape.wideFactor && t < minRoot) {
            minRoot = t;
            hit = new Hit(shape, minRoot, PVector.add(ray.origin, PVector.mult(ray.direction, minRoot)), new PVector(0, 1, 0), ray); 
          }
        }

        //Round body intersection
        float a = pow(ray.direction.x, 2) + pow(ray.direction.z, 2) - pow(shape.wideFactor * ray.direction.y, 2);
        float b = 2 * ray.origin.x * ray.direction.x - 2 * ray.direction.x * shape.location.x + 2 * ray.origin.z * ray.direction.z - 2 * ray.direction.z * shape.location.z - 2 * pow(shape.wideFactor, 2) * ray.origin.y * ray.direction.y + 2 * pow(shape.wideFactor, 2) * ray.direction.y * shape.location.y;
        float c = pow(ray.origin.x, 2) + pow(shape.location.x, 2) - 2 * ray.origin.x * shape.location.x + pow(ray.origin.z, 2) - 2 * ray.origin.z * shape.location.z + pow(shape.location.z, 2) - pow(shape.wideFactor * ray.origin.y, 2) + 2 * pow(shape.wideFactor, 2) * ray.origin.y * shape.location.y - pow(shape.wideFactor * shape.location.y, 2);
        float determinant = pow(b, 2) - (4 * a * c);

        t = 0.0;
        if (determinant > 0) {
          float[] roots = {( -1 * b + sqrt(determinant) ) / (2 * a), ( -1 * b - sqrt(determinant) ) / (2 * a)};
          if (roots[0] > 0 && roots[1] > 0) t = roots[0] < roots[1] ? roots[0] : roots[1];
          else if (roots[0] < 0 && roots[1] > 0) t = roots[1];
          else if (roots[0] > 0 && roots[1] < 0) t = roots[0];
          else t = 0.0;
          
          //Check if within span of cone height
          float hitOrigin_y = ray.origin.y + (t * ray.direction.y);
          if (t > 0.0 && t < minRoot && hitOrigin_y >= shape.location.y && hitOrigin_y <= (shape.location.y + shape.h)) {
            minRoot = t;
            PVector hitOrigin = PVector.add(ray.origin, PVector.mult(ray.direction, minRoot));
            hit = new Hit(shape, minRoot, hitOrigin, new PVector(2 * (hitOrigin.x - shape.location.x), -2 * shape.wideFactor * (hitOrigin_y - shape.location.y), 2 * (hitOrigin.z - shape.location.z)).normalize(), ray);
          }   
        }
      } 
      return hit;
}

// Calculates the color for a hit, including diffuse, specular, and ambient, as well as accounting for shadows and reflection
PVector calculateColor(Hit hit, int depth) {
  if (hit == null) return background;
  
  PVector colors = hit.shape.ambient;
  for (Light light: lights) {
    //Diffuse color
    PVector l = PVector.sub(light.location, hit.intersection).normalize();
    float normalDotL = max(0, PVector.dot(hit.normal, l));
    PVector diffCounter = PVector.mult(light.colors, normalDotL);
    
    //Specular color
    PVector eyeRay = PVector.sub(hit.ray.origin, hit.intersection).normalize();
    float hDotN = pow(PVector.dot(PVector.add(eyeRay, l).normalize(), hit.normal), hit.shape.P);
    PVector specCounter = PVector.mult(light.colors, hDotN);
    
    //Shadow ray
    PVector origin = PVector.add(hit.intersection, PVector.mult(hit.normal, 0.0001));
    PVector direction = PVector.sub(light.location, hit.intersection).normalize();
    if (intersection(new Ray(origin, direction), light) == null) {
      colors = PVector.add(colors, new PVector(diffCounter.x * hit.shape.diffuse.x, diffCounter.y * hit.shape.diffuse.y, diffCounter.z * hit.shape.diffuse.z));
      colors = PVector.add(colors, new PVector(specCounter.x * hit.shape.specular.x, specCounter.y * hit.shape.specular.y, specCounter.z * hit.shape.specular.z));
    }
  }

  //Reflection
  PVector reflection_color = new PVector(0, 0, 0);
  if (hit.shape.Krefl > 0 && depth < 10) {
    PVector rayOrigin = PVector.add(hit.intersection, PVector.mult(hit.normal, 0.0001));
    PVector eyeRay = PVector.sub(hit.ray.origin, hit.intersection).normalize();
    float NdotE = PVector.dot(hit.normal, eyeRay);
    PVector reflection = PVector.sub(PVector.mult(hit.normal, 2 * NdotE), eyeRay).normalize();
    reflection_color = calculateColor(intersection(new Ray(rayOrigin, reflection), null), depth + 1);
  }

  return PVector.add(colors, PVector.mult(reflection_color, hit.shape.Krefl));
}

void draw() {
}
