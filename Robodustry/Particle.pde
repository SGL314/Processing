class Particle extends Materia{
	float x;
	float y;
	float vx;
	float vy;
	float r;
	String type;
	int cor;
	LinkedHashMap<Material,Float> materials = new LinkedHashMap<Material,Float>();
	//
	
	Particle(String material,float qtd,float x, float y) {
		this.materials.put(Cfg.getMaterial(material),qtd);
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
		fill(getMixedColor());
		ellipse(x,y,r,r);
	}
	private color getMixedColor() {
		int r=0,g=0,b=0;
		float total = 0;
		for (Material mat : materials.keySet()) {
			float qtd = materials.get(mat);
			total += qtd;
			r += red(mat.cor) * qtd;
			g += green(mat.cor) * qtd;
			b += blue(mat.cor) * qtd;
		}
		r /= total;
		g /= total;
		b /= total;
		return color(r,g,b);
	}

	public void addMaterial(String matS,float qtd) {
		Material mat = Cfg.getMaterial(matS);
		if (materials.containsKey(mat)) {
			materials.put(mat,materials.get(mat) + qtd);
		} else {
			materials.put(mat,qtd);
		}
	}
}