class Button{
	
	float px, py, w, h, r;
	int tamText = 0;
	int typeDetection;
	String id, type,name;
	color cor;
	Construction construction = null;
	String material = null;
	float qtdMaterial = 0;
	
	Button(String name,String type, String id,color cor, float x, float y, float w, float h,int typeDetection) { // rect
		this.name = name;
		this.cor = cor;
		this.typeDetection = typeDetection;
		this.id = id;
		this.type = type;
		this.px = x;
		this.py = y;
		this.w = w;
		this.h = h;
		setupMe();
		
	}
	Button(String name,String type, String id,color cor, int tamText,float x, float y, float w, float h,int typeDetection) { // rect
		this.name = name;
		this.cor = cor;
		this.typeDetection = typeDetection;
		this.id = id;
		this.type = type;
		this.px = x;
		this.py = y;
		this.w = w;
		this.h = h;
		this.tamText = tamText;
		setupMe();
		
	}
	Button(String name,String type, String id,color cor, float x, float y, float r,int typeDetection) { // circle
		this.name = name;
		this.cor = cor;
		this.typeDetection = typeDetection;
		this.id = id;
		this.type = type;
		this.px = x;
		this.py = y;
		this.r = r;
		setupMe();
		
	}
	private void setupMe() {
		// detect piece
		for (int i = 0; i < Cfg.prefabs.size(); i++) {
			Construction cons = Cfg.prefabs.get(i);
			if (cons.id.equals(id)) {
				this.construction = cons.copy();
				switch(cons.id) {
					// circle
					case "connector" :
						this.construction.px = px + w / 2;
						this.construction.py = py + this.construction.tam / 2 + 5;
						break;
					// rect
					case "pipe" : 
						this.construction.px = px + w / 2 - this.construction.tam / 2;
						this.construction.py = py + 5;
						break;
					default:
					println("Id desconhecido: '" + cons.id + "'; para desenhar em button (" + name + "), Button.setupMe()");
				}
				break;
			}
		}
		if (tamText ==  0) defineTamText();
	}
	private void defineTamText() {
		tamText = 100;
		textSize(tamText);
		switch(type) {
			case "circle":
				while(textWidth(name) > r) {
					tamText--;
					textSize(tamText);
				}
				break;
			case "rect":
				while(textWidth(name) > w) {
					tamText--;
					textSize(tamText);
				}
				break;
		}
	}
	private String getRealName() {
		if (name.startsWith("var-")) {
			switch(name.split("-")[1]) {
				case "onHandConstruction":
					if (onHandConstruction!= null) return onHandConstruction.name;
					break;
				default:
					println("ERRO ao processar real name in BYtton.getRealName():\n   type nao reconhecido: '" + name + "'");
			}
		}else if (name.startsWith("invmat-")) {
			if (this.material == null) this.material = Inv.getMaterial(name.split("-")[1]);
			this.qtdMaterial = Inv.getQtdMaterial(this.material);
			return this.material.name;
 		}
		return name;
	}
	private void redefineAll() {
		switch(this.id) {
			case "onHand":
				if (onHandConstruction == null) return;
				this.id = onHandConstruction.id;// redefine o construction pra ser detectado no setup
				setupMe(); // define o construction
				this.id = "onHand"; // volta pro inicial
				// this.construction.py += this.construction.tam / 2 + 5;
				break;
		}
	}
	
	void show() {
		redefineAll();
		//
		noStroke();
		fill(this.cor);
		switch(type) {
			case "circle":
				circle(px,py,r);
				break;
			case "rect":
				rect(px,py,w,h);
				//
				fill(0);
				textSize(tamText);
				String nameNow = getRealName();
				text(nameNow,px + w / 2 - textWidth(nameNow) / 2,py + h - 1);
				break;
		}
		if (this.construction != null) {
			this.construction.show();
			Material[] mats = this.construction.materials.keySet().toArray(new Material[0]);
			for (int i = 0; i < this.construction.materials.size(); i++) {
				Material mat = mats[i];
				float x = px + 10 + i * 15, y = py + 10 + this.construction.tam + 5;
				mat.px = x;
				mat.py = y;
				mat.show();
				int qtd = this.construction.materials.get(mat).intValue();
				fill(0);
				text(qtd,x - textWidth("" + qtd) / 2,y + 1 + textAscent() + textDescent());
			}
		}
		else if (this.material != null){
				float x = px, y = py;
				this.material.px = x;
				this.material.py = y;
				this.material.show();
				fill(0);
				text(qtdMaterial,x - textWidth("" + qtdMaterial) / 2,y + 1 + textAscent() + textDescent());
			}
		}
	}
	
	boolean[] typeOfDetection(boolean left, boolean right) {
		boolean[] ret = {true,false};
		// println(left + " " + right);
		switch(typeDetection) {
			case 0:
				if (left) println("Acionado: " + id);
				ret[1] = left;
				break;
			case 1:
				ret[1] = right;
				break;
			case 2:
				ret[1] = left ||  right;
				break;
		}
		return ret;
	} 
	
	boolean[] seeIfClicked(float mpx,float mpy, boolean left, boolean right) {
		switch(type) {
			case "circle":
				if (dist(mpx,mpy,px,py) < r) {
					return typeOfDetection(left,right);
				}
				break;
			case "rect":
				if (mpx > px && mpx < px + w && mpy > py && mpy < py + h) {
					
					return typeOfDetection(left,right);
				}
				break;
		}
		boolean[] ret = {false,false};
		return ret;
	}
}
