#include "PVector.h"

class GameObject {
public:
  PVector pos;
  int cor[3] = {0, 0, 0};
  float raw = 0;
  float angle = -1;
  int timeFunc = 0;
  int created = millis();
  bool inRunning = true;
  int naturalClock = 0;

  GameObject(PVector _pos, int _cor[3]) : pos(_pos) {
    this->cor[0] = _cor[0];
    this->cor[1] = _cor[1];
    this->cor[2] = _cor[2];
  }

  GameObject(PVector _pos) : pos(_pos) {}

  virtual void update() {}
  virtual void display() {}
  virtual void putEstatistics() {}

  virtual ~GameObject() {}
};