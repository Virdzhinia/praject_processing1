int imgWidth = 800;
int imgHeight = 800;
int maxShapes = 100;
ArrayList<Shape> shapes = new ArrayList<Shape>();
int screenshotCounter = 0; 

void settings() {
  size(imgWidth, imgHeight);
}

void setup() {
  frameRate(30);
  generateShapes();
}

void draw() {
  background(0);
  for (Shape s : shapes) {
    s.update();
    s.display();
  }

  if (frameCount % 240 == 0) {
    regenerateShapes();
  }
  
  
  if (frameCount % 30 == 0 && screenshotCounter < 9) {
    saveFrame("screenshot-######.png");
    screenshotCounter++;
  }
}

void generateShapes() {
  for (int i = 0; i < maxShapes; i++) {
    shapes.add(new Shape(random(width), random(height), random(20, 100), int(random(3))));
  }
}

void regenerateShapes() {
  for (Shape s : shapes) {
    s.setNewTarget();
  }
}

class Shape {
  float x, y, size;
  int type;
  float targetX, targetY;
  float noiseOffsetX, noiseOffsetY;
  color col;

  Shape(float tempX, float tempY, float tempSize, int tempType) {
    x = tempX;
    y = tempY;
    size = tempSize;
    type = tempType;
    noiseOffsetX = random(10);
    noiseOffsetY = random(10);
    col = color(random(100, 255), random(100, 255), random(100, 255), random(150, 255));
    setNewTarget();
  }

  void setNewTarget() {
    targetX = random(width);
    targetY = random(height);
  }

  void update() {
    float noiseFactor = 0.01;
    x = lerp(x, targetX + map(noise(noiseOffsetX), 0, 1, -50, 50), 0.02);
    y = lerp(y, targetY + map(noise(noiseOffsetY), 0, 1, -50, 50), 0.02);
    noiseOffsetX += noiseFactor;
    noiseOffsetY += noiseFactor;
  }

  void display() {
    noStroke();
    fill(col);
    switch (type) {
      case 0:
        ellipse(x, y, size, size);
        break;
      case 1:
        rect(x, y, size, size);
        break;
      case 2:
        polygon(x, y, size, int(random(5, 10)));
        break;
    }
  }

  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
