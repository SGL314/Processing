class Button{
	float px, py, w, h, r;
	int tamText = 0;
	int typeDetection;
	String id, type, name;
	color cor;
	Construction construction = null;
	Material material = null;
	boolean showMe = true,active = true,over = false;
	int typeSelection = 0;// 0 none, 1 yes, -1 no
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
		initialProcess();
		
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
		initialProcess();
		
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
		initialProcess();
		
	}
	private void initialProcess() {
		update();
		setupMe();
	}
	private void setupMe() {
		
		// detect piece
		for (int i = 0; i < Cfg.prefabs.size(); i++) {
			Construction cons = Cfg.prefabs.get(i);
			if (cons.id.equals(id)) {
				if (onHandConstruction == null) this.construction = cons.copy();
				else this.construction = onHandConstruction.copy();
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
					// macropieces
					case "collector":
						((MacroPiece)this.construction).piecePivot.px = px + w / 2;
						((MacroPiece)this.construction).piecePivot.py = py + this.construction.tam / 2 + 5;
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
		if (id.startsWith("var-")) {
			switch(id.split("-")[1]) {
				case "onHand":
					if (onHandConstruction!= null) return onHandConstruction.name;
					break;
				default:
				println("ERRO ao processar real name in Button.getRealName():\n   type nao reconhecido: '" + name + "'");
			}
		} else if (id.startsWith("invmat-")) {
			if (this.material == null) {
				println(id.split("-")[1]);
				this.material = Inv.getMaterial(id.split("-")[1]);
				this.material.tam *= 3;
			}
			this.qtdMaterial = Inv.getQtdMaterial(this.material.id);
			return this.material.name;
		} else if (id.startsWith("optMats-")) { // options dos materials
			// return id.split("-")[1]+"-"+id.split("-")[2]; // retorno da posição bonitinha
			// return "";
			// tem q deixar o nome normal
		}
		return name;
	}
	private boolean redefineAll() {
		switch(this.id) {
			case "var-onHand":
				if (onHandConstruction == null) return true;
				this.id = onHandConstruction.id;// redefine o construction pra ser detectado no setup
				setupMe(); // define o construction
				this.id = "var-onHand"; // volta pro inicial
				// this.construction.py += this.construction.tam / 2 + 5;
				break;
			default:
			if (this.id.contains("-")) {
				switch(this.id.split("-")[0]) {
					case "invmat":
						if (!Inv.dislockedMaterials.get(this.id.split("-")[1])) showMe = false;
						else showMe = true;
						break;
					case "lcl" : // a local is just a local, not a button, so it will be innactivated
						active = false;
						break;
				}
			}
		}
		return true;
	}
	
	void show() {
		if (!showMe) return;
		boolean textShown = false;
		//
		noStroke();
		switch(typeSelection) {
			case 0:
				fill(this.cor);
				break;
			case 1:
				fill(#00FF00);
				break;
			case - 1:
				fill(#FF0000);
				break;
		}
		switch(type) {
			case "circle":
				circle(px,py,r);
				break;
			case "rect":
				rect(px,py,w,h);
				
				break;
		}
		//
		fill(0);
		textSize(tamText);
		String nameNow = getRealName();
		// switch mais simples pra definir as paradas
		String initial = nameNow.split("-")[0];
		switch(initial) {
			case "optMats":
				textShown = true;
				if (this.material != null) {
					this.material.px = px + 3 * w / 2;
					this.material.py = py + h / 2;
					this.material.show();
				}
				break;
			case "conf":
				String[] aux;
				textShown = true;
				if (this.over) {
					aux = new String[Cfg.timers.size() - 1]; // - 1 pro init
					int pi = 0;
					for (String key : Cfg.timers.keySet()) { 
						if (!key.startsWith("e_")) continue;
						aux[pi] = key.split("_")[1] + " " + Cfg.timers.get(key) + "ms";
						pi++;
					}
				} else{
					String[] keys = {"Particles","Pieces","Total"};
					aux = new String[keys.length];
					for (int j = 0; j < keys.length; j++) {
						aux[j] = keys[j] + " " + Cfg.timers.get("e_" + keys[j]) + "ms";
					}
				}
				fill(255,255,255);
				int j=0;
				for (j = 0; j < aux.length; j++) {
					text(aux[j],px + 2,py + 10 + (textAscent() + textDescent()) * j);
				}
				if (Cfg.adminMode){
					int qtdPcs = constructions.size();
					int qtdPrts = particles.size();
					text(qtdPcs+" Pcs.",px + 2,py + 10 + (textAscent() + textDescent()) * j);j++;
					text(qtdPrts+" Prts.",px + 2,py + 10 + (textAscent() + textDescent()) * j);j++;
				}
				over = false;
				break;
			default:
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
			else if (this.material != null) {
				textShown = true;
				nameNow = Cfg.getAbrevName(nameNow,3);
				text(nameNow,px + w / 2 - textWidth(nameNow) / 2,py + 10);
				float x = px + w / 2, y = py + this.material.tam / 2 + 12;
				this.material.px = x;
				this.material.py = y;
				this.material.show();
				String txt = "" + round(qtdMaterial * 1000) / 1000f;
				fill(0);
				text(txt,x - textWidth(txt) / 2,py + h - 2);
			}
			break;
		}
		
		if (!textShown) text(nameNow,px + w / 2 - textWidth(nameNow) / 2,py + h - 1);
	}
	void update() {
		redefineAll();
	}
	
	boolean[] typeOfDetection(boolean left, boolean right) {
		boolean[] ret = {true,false};
		if (!active) return ret;
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
