public class Menu{
	private ArrayList<Button> buttons = new ArrayList<Button>();
	String name;
	boolean active = false;
	color cor;
	float px,py,w,h;
	
	
	Menu(String name,color cor) {
		this.name = name;
		this.cor = cor;
	}
	
	void defineConfigurations(float px,float py, float w,float h) {
		this.px = px;
		this.py = py;
		this.w = w;
		this.h = h;
	}
	
	void addButton(Button bt) {
		buttons.add(bt);
	}
	
	void show() {
		noStroke();
		fill(cor);
		rect(px,py,w,h);
		//
		for (Button bt : buttons) {
			bt.show();
		}
	}
	
	String update(float mx,float my,boolean left,boolean right) {
		String defaultReturn = "none";
		boolean retorno = false;
		for (Button bt : buttons) {
			bt.update(); // talvez seja util
			boolean[] ret = bt.seeIfClicked(mx,my,left,right); // passed, clicked
			if (ret[0]) {
				if (this.name.equals("Putting") && onHandConstruction != null) onHandConstruction.hide = true;
				if (ret[1]) {
					toggleButton(bt);
					retorno = true;
				}
				defaultReturn = bt.id;// fora do if de cima pra detectar qnd esta emcima de um botão, pra n poder colcoar iten no mapa
				// println("Clicked in " + bt.id);
				bt.over = true;
			}
			
			
			// materials to chose
			if (name.equals("Putting") && onHandConstruction != null && bt.id.startsWith("optMats-")) {
				String[] id = bt.id.split("-");
				int i = int(id[1]);
				int j = int(id[2]);
				if (onHandConstruction.materialsOptions.size() > 0) {
					bt.showMe = false;
					if (onHandConstruction.materialsOptions.size() > i) {
						LinkedHashMap<Material,Float> mats = onHandConstruction.materialsOptions.get(i);
						if (mats.size() > j) {
							// println(mats);
							bt.showMe = true;
							Material mat = new ArrayList<>(mats.keySet()).get(j);
							if (ret[1]) {
								// println("Changing material to " + mat.name);
								int p =0;
								LinkedHashMap<Material,Float> mats2 = new LinkedHashMap<Material,Float>();
								// println(i);
								for (Material mat1 : onHandConstruction.materials.keySet()) {
									// println(mat1.id);
									if (p==i){
										mats2.put(mat, mats.get(mat));
										if (p==0) onHandConstruction.material = mat;
									} else{
										mats2.put(mat1, onHandConstruction.materials.get(mat1));
										if (p==0) onHandConstruction.material = mat1;
									}
									p++;
								}
								onHandConstruction.materials = mats2;
								Cfg.redefinePreFabs(onHandConstruction);
							}
							bt.material = mat;
							if (Cfg.containsMatchMaterials(onHandConstruction.materials,mat)) {
								bt.typeSelection = 1;
							} else {
								bt.typeSelection = -1;
							}
							// bt.name = Cfg.getAbrevName(mat.name,3);
						}
					}
				}
			}
			if (retorno) return defaultReturn;
			
		}
		return defaultReturn;
	}
	
	void deactiveAllLess(String id) {
		for (Button bt : buttons) {
			if (bt.id == id) continue;
			// println("Deactivating " + bt.id);
			modusButton(bt,false);
		}
	}
	void deactiveAll() {
		// println("Deactivating All from " + name);
		for (Button bt : buttons) {
			modusButton(bt,false);
		}
	}
	
}