#include "Sphere.pde"

  vector<Sphere*> spheres = new vector<Sphere*>();
float raio = 4, tamGrid = raio*2;
boolean showGrid = false;
vector<vector<vector<Sphere*>>> grid;

// void create(int);

void setup() {
  size(800, 800);
  create(10);
  grid = vector<vector<vector<Sphere*>>>(width/tamGrid, vector<vector<Sphere*>>(height/tamGrid));
  for (int i = 0; i < width/tamGrid; i++) {
    for (int j = 0; j < height/tamGrid; j++) {
      grid[i][j] = vector<Sphere*>();
    }
  }
}

void create(int n) {
  for (int i = 0; i < n; i++) {
    float x = random(0, width);
    float y = random(0, height);
    float r = raio;//random(5,10);
    color c = color(random(255), random(255), random(255));
    spheres.push_back(new Sphere(x, y, r, c));
    spheres.back()->vx = random(-2, 2);
    spheres.back()->vy = random(-2, 2);
  }
}
void realGrid() {
  stroke(0.2);
  for (int i = 0; i < width; i += tamGrid) {
    // line(i, 0, i, height);
    // line(0, i, width, i);
    for (int j = 0; j < width; j += tamGrid) {
      for (Sphere* sp : grid[i/tamGrid][j/tamGrid]) {
        // fill(sp->c);
        // rect(i, j, tamGrid, tamGrid);
        for (int a = -1; a <= 1; a++) {
          for (int b = -1; b <= 1; b++) {
            if (a==0 && b==0) continue;						
            for (Sphere* sp2 : grid[(i+a)/tamGrid][(j+b)/tamGrid]) {
							if (sp2 != sp) {
								if (dist(sp->x, sp->y, sp2->x, sp2->y) <= sp->radius+sp2->radius) {
									color temp = color(red(sp->c)/2+red(sp2->c)/2, green(sp->c)/2+green(sp2->c)/2, blue(sp->c)/2+blue(sp2->c)/2);
									sp2->c = temp;
									sp->c = temp;
								}
							}
            }
          }
        }
      }
    }
  }
}

void draw() {
  // Main program code here
  background(#ffffff);
  if (showGrid) realGrid();
  for (int i = 0; i < width/tamGrid; i++) {
    for (int j = 0; j < height/tamGrid; j++) {
      grid[i][j].clear();
    }
  }
  for (Sphere* sp : spheres) {
    sp->log();
    sp->draw();
    grid[sp->x/tamGrid][sp->y/tamGrid].push_back(sp);
  }
  if (!showGrid) {
    for (Sphere* sp : spheres) {
      // colorama
      for (Sphere* sp2 : spheres) {
        if (sp2 != sp) {
          if (dist(sp->x, sp->y, sp2->x, sp2->y) <= sp->radius+sp2->radius) {
            color temp = color(red(sp->c)/2+red(sp2->c)/2, green(sp->c)/2+green(sp2->c)/2, blue(sp->c)/2+blue(sp2->c)/2);
            sp2->c = temp;
            sp->c = temp;
          }
        }
      }
    }
  }
}

void keyPressed() {
  switch (key) {
  case 'g':
    showGrid = !showGrid;
    break;
  case 'c':
    spheres.clear();
    break;
  case 'r':
    create(1000);
    break;
  }
}
