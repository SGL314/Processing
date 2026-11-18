class Sphere {
  float x, y;
  float vx, vy, angle;
  float radius;
  color c;

  Sphere(float x, float y, float radius, color c) {
    this->x = x;
    this->y = y;
    this->radius = radius;
    this->c = c;
    this->vx = 0;
    this->vy = 0;
    this->angle = 0;
  }

  void log() {
    this->x += this->vx;
    this->y += this->vy;
    boolean doit = false;
    if (this->x-this->radius <= 0 || this->x+this->radius >= width) {
      this->vx *= -1;
      doit = true;
    }
    if (this->y-this->radius <= 0 || this->y+this->radius >= height) {
      this->vy *= -1;
      doit = true;
    }
    if (doit) {
      this->x += this->vx;
      this->y += this->vy;
    }
  }

  void draw() {
    fill(c);
    noStroke();
    circle(this->x, this->y, this->radius*2);
  }
}
