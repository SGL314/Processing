
class Bullet extends GameObject{
  float x, y, speed, angle, raio, damage=5;
  String format;
  String localFrom = "space";
  int marked = 0,time=millis();
  color cor;

  Bullet(String format, float x, float y, float angle, float speed, color cor, float raio) {
    this.format = format;
    this.raio = raio;
    defAll(cor, x, y, angle, speed);
  }
  void defAll(int cor, float x, float y, float angle, float speed) {
    this.angle = angle;
    this.cor = cor;
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.angle = angle;
  }

  boolean update() {
    this.x += this.speed * cos(this.angle*PI/180);
    this.y -= this.speed * sin(this.angle*PI/180);
		float distAu = dist(this.x, this.y, aurora.x, aurora.y);
		if (aurora.bareer && distAu >= aurora.raioActionBareer*aurora.r-this.raio && distAu <= aurora.raioActionBareer*aurora.r+this.raio) {
			float alp,bet,gam,m=abs((aurora.x-this.x)/(aurora.y-this.y));
			alp = (atan2(aurora.y-this.y, this.x-aurora.x)*180/PI);
			bet = (this.angle-alp)%180;
			gam = alp+180-2*bet;
			this.angle = gam;
			this.x += this.speed * cos(this.angle*PI/180);
			this.y -= this.speed * sin(this.angle*PI/180);
			// println(distAu+" "+alp+" "+bet+" "+gam+" "+x+" "+y);
		}
    for (int i = 0; i < bullets.size(); i++) {
      if (bullets.get(i) == this) continue;
      if (dist(this.x, this.y, bullets.get(i).x, bullets.get(i).y) <= this.raio+bullets.get(i).raio) {
        removeBullets.add(bullets.get(i));
				this.remove();
				bullets.get(i).remove();
        return false;
      }
    }
    if (this.localFrom != "planet" && dist(this.x, this.y, aurora.x, aurora.y) <= this.raio+aurora.r) {
      removeBullets.add(this);
      this.dano(aurora);
      return false;
    }
    return true;
  }
  void dano(Planet p) {
    p.vida -= this.damage;
  }
  void show() {
    noStroke();
    fill(cor);
    switch(this.format) {
    case "circle":
      circle(x, y, this.raio*2);
      break;
    }noStroke();
    switch(this.marked) {
			case 1:
				stroke(0, 255, 0);
				noFill();
				circle(x, y, this.raio*2+5);
				break;
			case 2:
				stroke(255, 0, 0);
				noFill();
				circle(x, y, this.raio*2+5);
				break;
    }
  }
}
