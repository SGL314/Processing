class Piece extends Construction {
	color cor,colorCannotPut = color(255,0,0,128);
	MacroPiece macroPiece = null;
	
	Piece(String name,String id,float tam,Material material, float px,float py,LinkedHashMap<Material,Float> materials) {
		super(id);
		super.type = "P";
		super.name = name;
		super.px = px;
		super.py = py;
		super.tam = tam;
		super.r = tam / 2;
		this.material = material;
		this.materials = materials;
	} 	

	void show(String modus,boolean what) {
		switch(modus) {
			case "canPut":
				_show(what);
				break;
		}
	}
	void show() {
		_show(true);
	}
	protected void _show(boolean canPut) {
		
		color corNow = material.cor;
		if (onHandConstruction==this) _showMaterials();
		if (!canPut || this.negativeShined) {
			corNow = colorCannotPut;
		}
		else if (selected && shined) {
			corNow = color(128,255,0,192);
		}
		else if (selected) {
			corNow = color(255,255,0,128);
		}
		else if (shined) {
			corNow = color(0,255,0,128);
		}
		stroke(1); // stroke here
		if (hide){
			noStroke();
			corNow = color(corNow,32);
		}
		fill(corNow);
		switch(id) {
			case "pipe" : // Pipe
				if (modusLinearis) {					
					if (effectiveModusLinearis) {
						noStroke();
						fill(corNow);
						beginShape();
						for (float[] p : points) {
							vertex(p[0],p[1]);
						}
						endShape(CLOSE);
					} else{
						//effective show
						stroke(corNow);
						strokeWeight(8);
						line(super.pax,super.pay,super.pbx,super.pby);
						strokeWeight(1);				
					}
				} else{
					rect(px,py,tam,tam);
				}
				break;
			case "connector" : // COnnector
				circle(px,py,tam);
				break;
			
			default:
				println("ERRO ao mostrar piece:\n   type '" + id + "' is not a type of piece Piece._show()");
		}
		if (Cfg.showIds){
			fill(0);
			textSize(20);
			String idShow = specificId.split("-")[0] + "-" + specificId.split("-")[1];
			text(idShow,px + 5,py + 5);
		}
		hide = false;
	}
	void _showMaterials() {
		float a = 0,stepY = 10;
		scale(1 / zoom);
		translate( -transX, -transY);
		textSize(10);
		for (Material mat : super.materials.keySet()) {
			mat.px = Cfg.localMaterials.px + 5;
			mat.py = Cfg.localMaterials.py + 15 + stepY * a;
			mat.show();
			float qtd = super.materials.get(mat) * super.coeMats;
			if (Inv.canRemoveMaterials(mat,qtd)) fill(0);
			else fill(#ED3737);
			text(qtd,mat.px + 5,mat.py);
			a++;
		}
		translate(transX, transY);
		scale(zoom);
	}
	
	void update() {
		switch(id) {
			case "pipe" : // Pipe
				if (modusLinearis) {					
					if (!effectiveModusLinearis) { // calculating vertexes
						super.pax = super.connections.get(0).px;
						super.pay	 = super.connections.get(0).py;
						float ang = atan2(super.pby - super.pay, super.pbx - super.pax) * 180 / PI;
						ang	 *= -1;
						if	(ang < 0) { // normalization
							ang	 *= -1;
							if	(ang > 90)
								ang	 = 270 - (ang - 90);
							else
								ang = 360 - ang;
						} 
						//	materials
						super.coeMats = sqrt(pow(super.pax - super.pbx,2) + pow(super.pay - super.pby,2)) / this.tam;
						
					}
				}
				break;
		}
		super.canPutByMaterials = true;
		for (Material mat : super.materials.keySet()) {
			float qtd = super.materials.get(mat) * super.coeMats;
			super.canPutByMaterials = super.canPutByMaterials && Inv.canRemoveMaterials(mat,qtd);
			if (!super.canPutByMaterials) break;
		}
	}
	void modusLinearis(float a, float b) {
		if	(effectiveModusLinearis) return;
		if	(!modusLinearis) {
			boolean canContinue = false;
			for	(String typeOfPipe : typeOfPipes) {
				if	(id.equals(typeOfPipe)) {
					canContinue = true;
					break;
				}
			}
			if	(!canContinue) {
				println("ERRO ao processar prefab:\n   type '" + id + "' is not a type of pipe");
				return;
			}
			
		}
		modusLinearis = true;
		super.pbx = a;
		super.pby = b;
	}
	
	
}