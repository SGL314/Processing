
class Ant;
class GameObject;
class Egg :
public GameObject {
public:
  string sex;
	float maturity = 0,growth = 1;
  Egg(PVector pos, int* cor) :
  GameObject(pos, cor) {
    this->sex = (random(100)==50)?"male":"female";
  }

	void update() {
		if (maturity<100) maturity+=growth;
	}

	void display() {
		fill(#FFCC95);
		noStroke();
		circle(this->pos.x, this->pos.y, 4);
	}
}
