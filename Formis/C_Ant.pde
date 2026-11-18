#include "PVector.h"
#include <cmath>

class Ant : public GameObject {
private:
  void defineMe() {
    life = maxLife;
    food = maxFood / 2.0f;
  }

public:
  float vel;
  float maxSpeed = 2;
  float maxForce = 0.1f;
  string state = "nothing";
  string type = "worker";
  float maxLife = 10, life = 0;
  float maxFood = 10, food = 0;
  float consumFood = .1f, growLifeByFood = 0.5f;
  int ovulos = 5, maxOvulos = 5;
  int esperms = 10000, maxEsperms = 10000;

  Ant(string _type, PVector pos, int cor[3]) : GameObject(pos, cor), type(_type) {
    this->vel = 1;
    this->angle = 360 - 45;
    this->raw = 8;
    if (type == "queen") {
      this->maxLife = 30;
      this->maxFood = 60;
      this->consumFood = 0.3f;
    }
    defineMe();
  }

  void putEstatistics() override {
    Engine::putEstatistics(this);
  }

  void update() override {
    this->pos.x += this->vel * cos(this->angle * PI / 180.0f);
    this->pos.y += this->vel * sin(this->angle * PI / 180.0f);
    if (this->vel > maxSpeed) this->vel = maxSpeed;

    if (millis() - this->timeFunc >= 100) {
      this->timeFunc = millis();
      this->naturalClock++;
    }

    if (this->naturalClock % 10 == 0) {
      this->food = (float)((int)(this->food * 100)) / 100.0f;
      if (this->food <= 0) {
        this->life -= 1;
      } else if (this->food > 0) {
        this->food = (float)((round(this->food * 100)) - (round(this->consumFood * 100))) / 100.0f;
        if (this->life < this->maxLife) {
          this->life += this->growLifeByFood;
        }
      }
      if (this->life < 0) {
        this->inRunning = false;
      }
      cout << this->food << " " << this->life << endl;
    }

    if (this->type == "queen" && this->naturalClock % 50 == 0) {
      if (this->ovulos > 0) {
        addThing((GameObject*)(new Egg(this->pos, this->cor)));
      }
    }
  }

  void display() override {
    fill(this->cor[0], this->cor[1], this->cor[2]);
    if (this->type == "worker") {
      circle(this->pos.x, this->pos.y, this->raw);
    } else if (this->type == "queen") {
      pushMatrix();
      translate(this->pos.x, this->pos.y);
      rotate(this->angle * PI / 180.0f);
      scale(1.0f / zoom);
      ellipse(0, 0, this->raw, this->raw * 2);
      popMatrix();
    }
    if (allInfo) {
      fill(#B2B2B2);
      rect(this->pos.x - this->raw - 4, this->pos.y - this->raw / 2, 4, this->raw);
      rect(this->pos.x + this->raw, this->pos.y - this->raw / 2, 4, this->raw);
      
      fill(0, 255, 0);
      float k = this->life / this->maxLife;
      rect(this->pos.x - this->raw - 4, this->pos.y - this->raw / 2 + this->raw * (1 - k), 4, this->raw * k);
      
      fill(#FF8324);
      k = this->food / this->maxFood;
      rect(this->pos.x + this->raw, this->pos.y - this->raw / 2 + this->raw * (1 - k), 4, this->raw * k);
    }
  }
};