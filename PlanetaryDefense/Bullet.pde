
class Bullet{
	float x, y,speed,angle,raio;
	String format;
	String localFrom = "space";
	boolean marked = false;
	color cor;
	
	Bullet(String format,float x, float y, float angle,float speed,color cor,float raio){
		this.format = format;
		this.raio = raio;
		defAll(cor,x,y,angle,speed);
	}
	void defAll(int cor,float x, float y, float angle,float speed){
		this.angle = angle;
		this.cor = cor;
		this.x = x;
		this.y = y;
		this.speed = speed;
		this.angle = angle;
	}
	
	boolean update(){
		this.x += this.speed * cos(this.angle*PI/180);
		this.y -= this.speed * sin(this.angle*PI/180);
		if ((this.x < 0 || this.x > width || this.y < 0 || this.y > height)){
			return false;
		}
		for (int i = 0; i < bullets.size(); i++){
			if(bullets.get(i) == this) continue;
			if (dist(this.x,this.y,bullets.get(i).x,bullets.get(i).y) <= this.raio+bullets.get(i).raio){
				removeBullets.add(bullets.get(i));
				return false;
			}
		}
		return true;
	}
	void remove(){
		// this = null;
	}
	void show(){
		noStroke();
		fill(cor);
		switch(this.format){
			case "circle":
				circle(x, y, this.raio*2);
				break;
		}
		if (this.marked){
			stroke(0,255,0);
			noFill();
			circle(x, y, this.raio*2+5);
		}
	}
}
