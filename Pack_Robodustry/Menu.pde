class Menu{
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
		for (Button bt : buttons) {
			boolean[] ret = bt.seeIfClicked(mx,my,left,right); // passed, clicked
			if (ret[0]) {
				if (ret[1]) {
					// println("Clicked in " + bt.id);
					toggleButton(bt);
					return bt.id;
				}
				// else println("Passed in " + bt.id);
			}
		}
		return "none";
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