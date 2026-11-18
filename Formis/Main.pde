
#include <string>
  #include <vector>

  using namespace std;
//
string mode = "nothing";
int rawMap = 500;
// Colors

int colorSheet[3] = {46, 162, 2};

int colorMeat[3]= {255, 84, 36};
// Gaming
vector<GameObject*> things = vector<GameObject*>();
vector<GameObject*> removeThings = vector<GameObject*>();
vector<GameObject*> addThings = vector<GameObject*>();
Ant* grabAnt = nullptr;
Food* grabFood = nullptr;

GameObject* thingOver = nullptr;
// Definitions

int colorAntDefault[3] = {227, 119, 0};
// Engine
float zoom=1, mvx=0, mvy=0;
int init = 0;
bool running = true;
bool allInfo = false;
// Funcs



void setup() {
  init = millis();
  size(800, 800);
}

void draw() {
  background(#644329);
  modus();
  scale(zoom);
  translate(mvx, mvy);
  if (grabAnt!=nullptr) {
    grabAnt->display();
  }else if (grabFood!=nullptr) {
    grabFood->display();
  }
  // detectOver();
  allThings();
}


void allThings() {
  thingOver = nullptr;
  if (running) {
    vector<GameObject*> nextThings = vector<GameObject*>();
    for (GameObject* g : things) {
      g->putEstatistics();
      if (g->inRunning) {
        nextThings.push_back(g);
        g->update();
        g->display();
      } else {
        removeThings.push_back(g);
      }
      if (thingOver==nullptr) detectOver(g);
    }
    // remove
    for (GameObject* g : removeThings) {
      delete g;
    }
    removeThings.clear();
    things.clear();
    for (GameObject* g : nextThings) {
      things.push_back(g);
    }
  } else {
    for (GameObject* g : things) {
      g->putEstatistics();
      g->display();
      if (thingOver==nullptr) detectOver(g);
    }
  }
  // ADD
  for (GameObject* g : addThings) {
    things.push_back(g);
  }
  // overThng
  if (thingOver!=nullptr) {
    stroke(2);
    fill(255, 0, 0);
    noFill();
    circle(thingOver->pos.x, thingOver->pos.y, thingOver->raw*3);
  }
}
void detectOver(GameObject* th) {
  // if (running) thingOver = (
  //   mouseX<=mvx+th->raw*zoom &&
  //   mouseX>=mvx-th->raw*zoom &&
  //   mouseY<=mvy+th->raw*zoom &&
  //   mouseY>=mvy-th->raw*zoom
  //   )?th:thingOver;
  // detecta se esta sobre o mouse
  if (running) {
    float worldMouseX = (mouseX - mvx) / zoom;
    float worldMouseY = (mouseY - mvy) / zoom;

    thingOver = (
      worldMouseX <= th->pos.x + th->raw &&
      worldMouseX >= th->pos.x - th->raw &&
      worldMouseY <= th->pos.y + th->raw &&
      worldMouseY >= th->pos.y - th->raw
      ) ? th : thingOver;
  }
}

void modus() {
  noStroke();
  fill(#BE00E5, 64);
  rect(20, 20, 200, 50);
  // run
  if (running) fill(0, 255, 0);
  else fill(255, 0, 0);
  rect(180, 25, 10, 10);
  // data
  textSize(20);
  fill(0);

  text("Ants: "+std::to_string(Engine::qtAnts), 150, 50);
  text("Foods: "+std::to_string(Engine::qtFoods)+"("+to_string(Engine::qtSourceFoods)+")", 150, 65);
  Engine::qtAnts = 0;
  Engine::qtFoods=0;
  Engine::qtSourceFoods=0;
  //
  if (mode!="nothing") text("Mode: "+mode, 40, 40);
  // running
  if (mode=="add-ant") {
    if (grabAnt!=nullptr) {
      grabAnt->pos = PVector(mouseX, mouseY);
      
    } else {
      float k = random(1)+0.05;
      int movColor[3] = {(int)(colorAntDefault[0]*k),
        (int)(colorAntDefault[1]*k), (int)(colorAntDefault[2]*k)};
      grabAnt = new Ant("worker", PVector(mouseX, mouseY), movColor);
    }
    text("Type: "+grabAnt->type, 40, 60);
  } else if (mode=="add-food") {
    if (grabFood!=nullptr) {
      grabFood->pos = PVector(mouseX, mouseY);
      grabFood->display();
    } else {
      grabFood = new Food("sheet", PVector(mouseX, mouseY));
      grabFood->food = 1;
    }
    fillIt(defineCor(grabFood->type));
    text("Type Food: "+grabFood->type, 40, 60);
  }
}

void keyPressed() {
  key = tolower(key);
  if (key == 'a') {
    mode = ((mode=="add-ant")?"nothing":"add-ant");
  } else if (key == 'f') {
    mode = ((mode=="add-food")?"nothing":"add-food");
  } else if (key == ' ') {
    running = !running;
  } else if (key == 'i') {
    allInfo = !allInfo;
  } else {
    int num = -1;
    if (key-'1'>=0 && key-'0'<=9) num = key-'1';
    if (num!= -1) {
      if (mode=="add-food") {
        string foods[2] = {"sheet", "meat"};
        if (foods[num]!=grabFood->type) {
          Food* nf = new Food(foods[num], PVector(mouseX, mouseY));
          nf->food = grabFood->food;
          grabFood = nf;
          grabFood->update();
        }
      }
    }
    if (mode=="add-ant") {
      if (key == 'q' && grabAnt->type!="queen") {
        grabAnt = new Ant("queen", grabAnt->pos, grabAnt->cor);
      } else if (key == 'w' && grabAnt->type!="worker") {
        grabAnt = new Ant("worker", grabAnt->pos, grabAnt->cor);
      }
    }
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {


    if (mode=="add-ant") {
      things.push_back(grabAnt);
      grabAnt = nullptr;
    } else if (mode=="add-food") {
      things.push_back(grabFood);
      grabFood = nullptr;
    }
  }
}
void mouseWheel(MouseEvent event) {
  if (mode=="add-food") {
    grabFood->food += 50*event.getCount();
    if (grabFood->food<0) grabFood->food = 0;
    grabFood->update();
  } else {
    float oldZoom = zoom;

    zoom *= pow(2, event.getCount());

    float maxZ = 100;
    float minZ = 0.01;

    zoom = constrain(zoom, minZ, maxZ);

    float fator = zoom / oldZoom;

    mvx = mouseX / zoom - (mouseX / oldZoom - mvx);
    mvy = mouseY / zoom - (mouseY / oldZoom - mvy);
  }
}
void mouseDragged() {
  mvx += (mouseX - pmouseX)/zoom;
  mvy += (mouseY - pmouseY)/zoom;
}

// AUXS
int* defineCor(string type) {
  int* nada = new int[3];
  nada[0] = 0;
  nada[1] = 0;
  nada[2] = 255;
  if (type =="sheet") {
    return colorSheet;
  } else if (type == "meat") {
    return colorMeat;
  } else {
    // nada[2] = 255;
    return nada;
  }
  return nada;
}
float densityFood(string type) {
  if (type =="sheet") {
    return 10;
  } else if (type == "meat") {
    return 100;
  } else {
    // nada[2] = 255;
    return 1;
  }
}
void fillIt(int* cor) {
  fill(cor[0], cor[1], cor[2]);
}

