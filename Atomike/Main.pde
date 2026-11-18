#include "Sphere.pde"

  vector<Sphere*> spheres = new vector<Sphere*>();
float raio = 8, tamGrid = raio*2;
boolean showGrid = false,running = true;
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
  int gap = 50;
  for (int i = 0; i < n; i++) {
    float x = random(gap, width - gap);
    float y = random(gap, height - gap);
    float r = raio;//random(5,10);
    color c = color(random(255), random(255), random(255));
    int id = (int)(random(1000000000));
    spheres.push_back(new Sphere(id,x, y, r, c));
    spheres.back()->vel = .5f;
    spheres.back()->angle = random(0, 361);
  }
}
void realGrid() {
  if (showGrid)stroke(1);
  for (int i = 0; i < width; i += tamGrid) {
    if (showGrid){line(i, 0, i, height);
    line(0, i, width, i);}
    for (int j = 0; j < width; j += tamGrid) {
      for (Sphere* sp : grid[i/tamGrid][j/tamGrid]) {
        if (showGrid){fill(sp->c);
        rect(i, j, tamGrid, tamGrid);}
        for (int a = -1; a <= 1; a++) {
          for (int b = -1; b <= 1; b++) {
            if (a==0 && b==0) continue;						
            for (Sphere* sp2 : grid[(i+a)/tamGrid][(j+b)/tamGrid]) {
              if (sp2 != sp && sp->id > sp2->id) {
                // cout<<sp->id<<" "<<sp2->id<<endl;
                if (dist(sp->x, sp->y, sp2->x, sp2->y) <= sp->radius+sp2->radius) {
                  color TMP = color(red(sp->c)/2+red(sp2->c)/2, green(sp->c)/2+green(sp2->c)/2, blue(sp->c)/2+blue(sp2->c)/2);
                  // sp2->c = TMP;
                  // sp->c = TMP;
                  //
                  sp->collision(sp2);
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
  if (running) {
    realGrid();
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
  } else {
    for (Sphere* sp : spheres) {
      sp->draw();
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
    create(100);
    break;
  case ' ':
    running = !running;
    break;
  }
}
