#include "PVector.h"
  #include <cmath>

  int* defineCor(string t);
float densityFood(string type);
class Engine;

class Food :
public GameObject {
public:
  string type;
  float food=0;

  Food(string type, PVector pos) :
  GameObject(pos) {
    this->type = type;
    int* _cor = defineCor(type);
    this->cor[0] = _cor[0];
    this->cor[1] = _cor[1];
    this->cor[2] = _cor[2];
  }
  void putEstatistics();

  void update() {
    this->raw = sqrt(this->food/(densityFood(this->type)*PI));
    if (this->raw<5) this->raw = 5;
  }

  void display() {
    fill(this->cor[0], this->cor[1], this->cor[2]);
    circle(this->pos.x, this->pos.y, this->raw);
  }

  // void
};
void Food::putEstatistics() {
  Engine::putEstatistics(this);
}
