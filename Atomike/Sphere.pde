

class Sphere {
  int id;
  float x, y;
  float vel, angle;
  float radius;
  float mass = 10;
  color c;

  Sphere(int id_, float x, float y, float radius, color c) {
    this->id = id_;
    this->x = x;
    this->y = y;
    this->radius = radius;
    this->c = c;
    this->vel=0;
    this->angle = 0;
  }

  void log() {
    float vx, vy;
    vx = this->vel*cos(this->angle*PI/180);
    vy = this->vel*sin(this->angle*PI/180);
    this->x += vx;
    this->y += vy;
    boolean doit = false;
    int gap = 50;
    if (this->x-this->radius <= 0+gap || this->x+this->radius >= width-gap) {
      vx *= -1;
      doit = true;
    }
    if (this->y-this->radius <= 0+gap || this->y+this->radius >= height-gap) {
      vy *= -1;
      doit = true;
    }
    if (doit) {
      this->x += vx;
      this->y += vy;
      this->angle = atan2(vy, vx)*180/PI;
    }
  }

  void collision(Sphere* s) {
    // delay(500);
    // draw();
    // mov
    float nx, ny;
    float dx = s->x - this->x;
    float dy = s->y - this->y;
    float d = dist(this->x, this->y, s->x, s->y);
    float overlap = this->radius + s->radius - d;
    cout<<"overlap: "<<overlap<<endl;
    if (overlap>0) {
      nx = dx/d;
      ny = dy/d;
      this->x += -nx * overlap / 2;
      this->y += -ny * overlap / 2;
      s->x -= -nx * overlap / 2;
      s->y -= -ny * overlap / 2;
      // background(#ffffff);
      // delay(250);
      dx = s->x - this->x;
      dy = s->y - this->y;
      d = dist(this->x, this->y, s->x, s->y);
      overlap = this->radius + s->radius - d;
      cout<<"new overlap: "<<overlap<<endl;
      // delay(250);
      // this->draw();
      // s->draw();
      // delay(1000);
    }
    // velocidte affasting
    float vxRel = s->vel*cos(s->angle*PI/180) - this->vel*cos(this->angle*PI/180);
    float vyRel = s->vel*sin(s->angle*PI/180) - this->vel*sin(this->angle*PI/180);
    if (vxRel * nx + vyRel * ny<0) {
      float phi = atan2(dy, dx);
      float v1n = this->vel*cos(this->angle*PI/180 - phi), v2n = s->vel*cos(s->angle*PI/180 - phi);
      float v1t = this->vel*sin(this->angle*PI/180 - phi), v2t = s->vel*sin(s->angle*PI/180 - phi);
      float e = 1, va, vb;
      va = (v1n*(this->mass - e*s->mass) + (1+e)*s->mass*v2n)/(this->mass + s->mass);
      vb = (v2n*(s->mass - e*this->mass) + (1+e)*this->mass*v1n)/(this->mass + s->mass);
      v1n = va;
      v2n = vb;
      this->vel = sqrt(v1n*v1n + v1t*v1t);
      s->vel = sqrt(v2n*v2n + v2t*v2t);
      this->angle = (phi + atan2(v1t, v1n)*180/PI);
      s->angle = (phi + atan2(v2t, v2n)*180/PI);
    }
  }

  void acollision(Sphere* s) {
    float v1x = this->vel * cos(this->angle * PI / 180.0);
    float v1y = this->vel * sin(this->angle * PI / 180.0);
    float v2x = s->vel * cos(s->angle * PI / 180.0);
    float v2y = s->vel * sin(s->angle * PI / 180.0);

    // Vetor posição atual (com overlap)
    float dx = s->x - this->x;
    float dy = s->y - this->y;
    float dSq = dx * dx + dy * dy;
    float sumR = this->radius + s->radius;

    if (dSq < sumR * sumR) {
      // Vetor velocidade relativa (v2 - v1)
      float dvx = v2x - v1x;
      float dvy = v2y - v1y;

      // Coeficientes da equação do 2º grau A*t^2 + B*t + C = 0
      float A = dvx * dvx + dvy * dvy;
      float B = -2.0 * (dx * dvx + dy * dvy);
      float C = dSq - (sumR * sumR);

      float delta = B * B - 4.0 * A * C;

      // Se houver raiz real válida, descobrimos o exato momento do passado (t)
      if (delta >= 0 && A != 0) {
        // Queremos a maior raiz t <= 1 (o instante exato que entraram em contato)
        float t = (-B + sqrt(delta)) / (2.0 * A);

        // Limita t entre 0 e 1 por segurança
        if (t < 0) t = 0;
        if (t > 1) t = 1;

        // 1. RECUAR AS POSIÇÕES PARA O INSTANTE DO IMPACTO NO PASSADO
        float backStep = (1.0 - t);
        this->x -= v1x * backStep;
        this->y -= v1y * backStep;
        s->x -= v2x * backStep;
        s->y -= v2y * backStep;

        // 2. RECALCULAR A NORMA DO CHOQUE NO INSTANTE DE CONTATO EXATO
        dx = s->x - this->x;
        dy = s->y - this->y;
        float dExact = sqrt(dx * dx + dy * dy);
        if (dExact == 0) return;

        float nx = dx / dExact;
        float ny = dy / dExact;

        // 3. CALCULAR VELOCIDADES DEPOIS DO CHOQUE
        float phi = atan2(dy, dx);
        float a1_rad = this->angle * PI / 180.0;
        float a2_rad = s->angle * PI / 180.0;

        float v1n = this->vel * cos(a1_rad - phi);
        float v1t = this->vel * sin(a1_rad - phi);
        float v2n = s->vel * cos(a2_rad - phi);
        float v2t = s->vel * sin(a2_rad - phi);

        float e = 1.0;

        float v1n_f = (v1n * (this->mass - e * s->mass) + (1.0 + e) * s->mass * v2n) / (this->mass + s->mass);
        float v2n_f = (v2n * (s->mass - e * this->mass) + (1.0 + e) * this->mass * v1n) / (this->mass + s->mass);

        this->vel = sqrt(v1n_f * v1n_f + v1t * v1t);
        s->vel = sqrt(v2n_f * v2n_f + v2t * v2t);

        this->angle = (phi + atan2(v1t, v1n_f)) * 180.0 / PI;
        s->angle = (phi + atan2(v2t, v2n_f)) * 180.0 / PI;

        // 4. AVANÇAR O RESTANTE DO FRAME COM AS NOVAS VELOCIDADES
        float newV1x = this->vel * cos(this->angle * PI / 180.0);
        float newV1y = this->vel * sin(this->angle * PI / 180.0);
        float newV2x = s->vel * cos(s->angle * PI / 180.0);
        float newV2y = s->vel * sin(s->angle * PI / 180.0);

        this->x += newV1x * backStep;
        this->y += newV1y * backStep;
        s->x += newV2x * backStep;
        s->y += newV2y * backStep;
      }
    }
  }

  void draw() {
    fill(c);
    noStroke();
    circle(this->x, this->y, this->radius*2);
  }
}
