class Particle extends Materia{
	float x;
	float y;
	float vx;
	float vy;
	float r;
	String type;
	int cor;
	Material material;
	//
	
	Particle(String material,float x, float y) {
		this.material = Cfg.getMaterial(material);
		this.x = x;
		this.y = y;
		r = tamSquare;
	}
	
	void update() {
		this.x += this.vx;
		this.y += this.vy;
	}
	
	void show() {
		noStroke();
		fill(material.cor);
		ellipse(x,y,r,r);
	}
}