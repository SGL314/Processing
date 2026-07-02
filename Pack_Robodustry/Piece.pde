class Piece extends Construction {
	color cor;
	Material material; // material geral
	
	
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
		if (!canPut) {
			corNow = color(255,0,0,128);
		}
		else if (selected && shined){
			corNow = color(128,255,0,192);
		}
		else if (selected){
			corNow = color(255,255,0,128);
		}
		else if (shined){
			corNow = color(0,255,0,128);
		}
		fill(corNow);
		switch(id) {
			case "pipe" : // Pipe
				if (modusLinearis) {					
					if (effectiveModusLinearis) {
						noStroke();
						fill(corNow);
						beginShape();
						for (PVector p : points) {
							vertex(p.x,p.y);
						}
						endShape(CLOSE);
					} else{
						float ang = atan2(super.pby - super.pay, super.pbx - super.pax) * 180 / PI;
						ang	 *= -1;
						if	(ang < 0) { // normalization
							ang	 *= -1;
							if	(ang > 90)
								ang	 = 270 - (ang - 90);
							else
								ang = 360 - ang;
						} 
						stroke(corNow);
						strokeWeight(8);
						line(super.pax,super.pay,super.pbx,super.pby);
						strokeWeight(1);
						textSize(10);
						fill(0);
						text(ang,super.pbx,super.pby);
					}
				} else{
					stroke(1);
					rect(px,py,tam,tam);
				}
				break;
			case "connector" : // COnnector
				stroke(1);
				circle(px,py,tam);
				break;
		}
	}
	
	void update() {
		// println(getFormatter());
	}
	void modusLinearis(float a, float b) {
		if (effectiveModusLinearis) return;
		if (!modusLinearis) {
			boolean canContinue = false;
			for (String typeOfPipe : typeOfPipes) {
				if (id.equals(typeOfPipe)) {
					canContinue = true;
					break;
				}
			}
			if (!canContinue) {
				println("ERRO ao processar prefab:\n   type '" + id + "' is not a type of pipe");
				return;
			}
			super.pax = this.px + this.tam / 2;
			super.pay = this.py + this.tam / 2;
		}
		modusLinearis = true;
		super.pbx = a;
		super.pby = b;
	}
	void effectiveModusLinearis() {
		effectiveModusLinearis = true;
		// pontos dos connects
		super.pax = super.connections.get(0).px;
		super.pay = super.connections.get(0).py;
		super.pbx = super.connections.get(1).px;
		super.pby = super.connections.get(1).py;
		// angulo
		float ang = atan2(super.pby - super.pay, super.pbx - super.pax) * 180 / PI;
		ang *= -1;
		if (ang < 0) { // normalization
			ang *= -1;
			if (ang > 90)
				ang = 270 - (ang - 90);
			else
				ang = 360 - ang;
		} 					
		float beta = 90 - ang;
		// println(beta);
		// println(super.pax + " " + super.pay + ";" + super.pbx + " " + super.pby);
		ang = ang / 180 * PI;
		beta = beta / 180 * PI;
		// connections
		super.connections.get(0).connections.add(this);
		super.connections.get(1).connections.add(this);
		// raws
		float r1 = super.connections.get(0).r, r2 = super.connections.get(1).r;
		
		// println(r1 + " " + r2);
		// points
		PVector[] pts = {
			new PVector(super.pax + cos(beta) * r1,super.pay - sin(beta) * r1 * ( -1)),
				new PVector(super.pbx + cos(beta) * r2,super.pby - sin(beta) * r2 * ( -1)),
				new PVector(super.pbx - cos(beta) * r2,super.pby + sin(beta) * r2 * ( -1)),
				new PVector(super.pax - cos(beta) * r2,super.pay + sin(beta) * r2 * ( -1))
			};
		int i = 0;
		for (PVector p : pts) {
			points[i] = p;
			i++;
		}
	}
	
	String getFormatter() {
		// P;Connector;connector;metal;init;0;0;metal,10_aluminium,4
		String text = super.type + ";" + super.name + ";" + super.id + ";" + material.id + ";" + super.tam;
		text += ";" + super.px + ";" + super.py + ";";
		
		for (int i = 0;i < materials.size();i++) {
			Material mat = materials.keySet().toArray(new Material[0])[i];
			float qtd = materials.get(mat);
			text += mat.id + "," + qtd;
			if (i < materials.size() - 1) text += "_";
		}
		return text;
	}
	String getStringOfMe() {
		// P;Connector;connector;metal;tam;px;py;metal,10_aluminium,4;
		// specificId;id_id_id;modusLin.;effect.ModusLin.;istypeofpipe;
		String text = getFormatter() + ";" + super.specificId + ";";
		
		for (int i = 0;i < connections.size();i++) {
			text += connections.get(i).specificId;
			if (i < connections.size() - 1) text += "_";
		}
		if (connections.size() == 0) text += "---";
		text += ";" + super.modusLinearis + ";" + super.effectiveModusLinearis + ";" + super.isTypeOfPipe;
		return text;
	}
	
	Construction copy() {
		Construction copy = Cfg.disformatter(this.getFormatter());
		return copy;
	}
	
	
}